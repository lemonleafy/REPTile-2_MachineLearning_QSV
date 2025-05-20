clc
clear
close all

bowtie = readmatrix("Bowtie_Matrix.xlsx")';
bowtie_range = bowtie(3,61:110);

c = 299792458;
c2 = c^2;
m0 = 9.109E-31;
b0 = 3.1E-5;
rE = 6.37E6;
q = 1.602E-19;
t0 = 1.3802;
t1 = 0.7405;

beta = struct2cell(load("beta.mat"));
beta = beta{1};
gamma = struct2cell(load("gamma.mat"));
gamma = gamma{1};
v = struct2cell(load("velocities.mat"));

trange = ['2023-04-19';'2024-06-19'];
start_datenum = datenum(trange(1,:));
end_datenum = datenum(trange(2,:));

detrend_flux_total = [];
drift_freq_total = [];
time_total = NaT();

g = 1;

for p = start_datenum:end_datenum
    datestring = datestr(p,'yyyy_mm_dd');
    disp(datestring)
    file_path_1 = ['CIRBE_L1_combined_science_',datestring,'_V0.nc'];
    file_path_2 = ['CIRBE_L1_Nom_science_',datestring,'_V0.nc'];
    fileID_CIRBE_1 = fopen(file_path_1);
    if fileID_CIRBE_1>0

intprd = double(ncread(file_path_1,"sci_intg_prd"))./1000;
ecounts = double(ncread(file_path_1,"Ecounts"));

for i = 1:length(intprd)
    ecounts(:,i) = ecounts(:,i)./intprd(i);
end

ecounts(ecounts < 1.5) = nan;
ecounts_flux = ecounts;

for i = 1:50
    ecounts_flux(i,:) = ecounts(i,:)/bowtie_range(i);
end

time = datetime(ncread(file_path_2,"time_ymdhms")');
alt = ncread(file_path_1,"Altitude");
lat = ncread(file_path_1,"Latitude");
long = ncread(file_path_1,"Longitude");


kext = 0;
options = [0,0,0,0,0];
sysaxes = 0;
maginput = zeros(1,25);

[Lm,~,Blocal,Bmin,~,~] = onera_desp_lib_make_lstar(kext,options,sysaxes,time,alt,lat,long,maginput);
L = abs(Lm);
L(L > 4) = nan;

y = sqrt(Bmin./Blocal);
ecounts_flux_avg = ecounts_flux;
drift_freq = ecounts_flux;

for i = 1:length(y)
    ty = t0 - (0.5 * ((t0 - t1) * (y(i) + sqrt(y(i)))));
    dy = ((4 * t0) - (((3*t0) - (5*t1)) * y(i)) - ( (t0-t1) * ( (y(i) * log(y(i))) + sqrt(y(i))  )))/12;
    d_t = dy/ty;
    column_avg = movmean(log10(ecounts_flux(:,i)),7,"omitmissing");
    %column_avg = movmean(ecounts_flux(:,i),7);
    ecounts_flux_avg(:,i) = 10.^column_avg;
    for j = 1:50
        vd = abs(((3 * m0 * c2 * gamma(j) * (beta(j)^2) * (L(i)^2))/(q*b0*rE)) * d_t);
        drift_freq(j,i) = (vd/(rE*y(i)))*3600;
    end
end

detrend_flux = log10(ecounts_flux) - log10(ecounts_flux_avg);
drift_freq(drift_freq>25) = nan;

%for i = 1:length(y)
%    if isnan(detrend_flux(2,i))
%        detrend_flux(1,i) = nan;
%    end
%    for j = 2:48
%        if isnan(detrend_flux(j-1,i)) & (isnan(detrend_flux(j+1,i)) | isnan(detrend_flux(j+2,i)))
%            detrend_flux(j,i) = nan;
%        end
%    end
%    if isnan(detrend_flux(48,i)) | isnan(detrend_flux(49,i))
%        detrend_flux(49:50,i) = nan;
%    end
%end

drift_freq(isnan(detrend_flux)) = nan;
detrend_flux(isnan(drift_freq)) = nan;

detrend_flux_alt = [];
drift_freq_alt = [];
time_alt = NaT();
j = 1;

for i = 1:length(y)
    if sum(isnan(detrend_flux(6:50,i))) < 35
        detrend_flux_alt(1:45,j) = detrend_flux(6:50,i);
        drift_freq_alt(1:45,j) = drift_freq(6:50,i);
        time_alt(j,1) = time(i);
        j = j+1;
    end
end

detrend_flux_fin = NaN(45,length(time_alt));
drift_freq_fin = NaN(45,length(time_alt));

if(~isempty(detrend_flux_alt))
for i = 1:length(time_alt)
    fluxes = detrend_flux_alt(:,i);
    C = ~isnan(fluxes);
    diffs = zeros(45,1);
    diffs(1) = C(1);
    diffs(2:45) = diff(C);
    if (length(find(diffs>0))) ~= (length(find(diffs<0)))
        diffs(45) = -1;
    end
    starts = find(diffs>0);
    stops = find(diffs<0);
    L = stops-starts;
    [~,k] = max(L);
    detrend_flux_fin(starts(k):stops(k),i) = detrend_flux_alt(starts(k):stops(k),i);
    drift_freq_fin(starts(k):stops(k),i) = drift_freq_alt(starts(k):stops(k),i);
end

dtrnd_flux = [];
drft_frq = [];
time_act = NaT();
b = 1;

for i = 1:length(time_alt)
    if sum(isnan(detrend_flux_fin(:,i))) < 35
        dtrnd_flux(:,b) = detrend_flux_fin(:,i);
        drft_frq(:,b) = drift_freq_fin(:,i);
        time_act(b,1) = time_alt(i);
        b = b+1;
    end    
end

if(~isempty(dtrnd_flux))

filename = ['drift_freq_',datestring,'.mat'];
save(filename,"dtrnd_flux","drft_frq","time_act")

detrend_flux_total = horzcat(detrend_flux_total,dtrnd_flux);
drift_freq_total = horzcat(drift_freq_total,drft_frq);
time_total = vertcat(time_total,time_act);

end

end
    end
end

save("zebra_stripes_data_totals","detrend_flux_total","drift_freq_total","time_total")


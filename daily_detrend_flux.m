clc
clear
close all

bowtie = readmatrix("Bowtie_Matrix.xlsx")';
bowtie_range = bowtie(3,61:110);

trange = ['2023-04-19';'2024-06-19'];
start_datenum = datenum(trange(1,:));
end_datenum = datenum(trange(2,:));

detrend_flux_total = [];
time_total = NaT();

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
ecounts_flux_avg = ecounts_flux;

for i = 1:length(time)
    column_avg = movmean(log10(ecounts_flux(:,i)),7,"omitmissing");
    %column_avg = movmean(ecounts_flux(:,i),7);
    ecounts_flux_avg(:,i) = 10.^column_avg;
end

detrend_flux = log10(ecounts_flux) - log10(ecounts_flux_avg);

filename = ['dtrnd_flux',datestring,'.mat'];
save(filename,"detrend_flux","time")

detrend_flux_total = horzcat(detrend_flux_total,detrend_flux);
time_total = vertcat(time_total,time);

    end
end

%%

%detrend_flux_totals = table("detrend_flux_total","time_total");
save("detrend_flux_totals","detrend_flux_total","time_total")


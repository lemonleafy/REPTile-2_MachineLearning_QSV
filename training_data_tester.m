clear
clc

totaldata = struct2cell(load("zebra_stripes_data_totals.mat"));
detrend_flux = totaldata{1};
drift_freq = totaldata{2};
time = totaldata{3};
time = time(2:length(time));

no_vals = [];
no_local_extremes = [];
local_extreme_rate = [];
no_local_max = [];
local_max_rate = [];
no_local_min = [];
local_min_rate = [];
mean_abs_dev = [];
diff_avg = [];
std_dev = [];
min_freq = [];
max_freq = [];
freq_range = [];
abs_avg = [];


for i = 1:length(time)
    no_vals(i) = sum(~isnan(detrend_flux(:,i)));
    indices = find(~isnan(detrend_flux(:,i)));
    a = indices(1);
    b = indices(length(indices));
    fluxes = detrend_flux(a:b,i);
    freqs = drift_freq(a:b,i);
    no_local_max(i) = sum(islocalmax(fluxes));
    no_local_min(i) = sum(islocalmin(fluxes));
    no_local_extremes(i) = no_local_max(i) + no_local_min(i);
    local_extreme_rate(i) = no_local_extremes(i)/no_vals(i);
    local_max_rate(i) = no_local_max(i)/no_vals(i);
    local_min_rate(i) = no_local_min(i)/no_vals(i);
    mean_abs_dev(i) = mad(fluxes);
    diff_avg(i) = mean(abs(diff(fluxes)));
    std_dev(i) = std(fluxes);
    min_freq(i) = min(freqs);
    max_freq(i) = max(freqs);
    freq_range(i) = max_freq(i) - min_freq(i);
    abs_avg(i) = mean(abs(fluxes));
end



%%

event_time = NaT();
event_time_edges = NaT();
event_edge_indices = [];

j = 1;
i = 1;

%for i = 1:(length(time)-1000)
while((length(time) - i) > 1000)
    disp(i)
    eventdatapoints = 1;
    timediff = duration(0,0,1);
    endindex = i;
    t = i;
    while timediff<duration(0,1,0)
        timediff = time(t+1)-time(t);
        if(timediff < duration(0,1,0))
            eventdatapoints = eventdatapoints+1;
            t = t+1;
        end
    end
    if(eventdatapoints > 100)
        event_time_edges(j,1) = time(i);
        event_time_edges(j,2) = time(t);
        timediff = time(t)-time(i);
        event_time(j,1) = time(t) - (timediff/2);
        event_edge_indices(j,1) = i;
        event_edge_indices(j,2) = t;
        j = j+1;
    end
    i = t+1;
end

%%

no_vals_avg = [];
no_local_extremes_avg = [];
local_extreme_rate_avg = [];
no_local_max_avg = [];
local_max_rate_avg = [];
no_local_min_avg = [];
local_min_rate_avg = [];
mean_abs_dev_avg = [];
diff_avg_avg = [];
std_dev_avg = [];
min_freq_avg = [];
max_freq_avg = [];
freq_range_avg = [];
abs_avg_avg = [];

for i = 1:length(event_time)
    no_vals_avg(i) = mean(no_vals(event_edge_indices(i,1):event_edge_indices(i,2)));
    no_local_extremes_avg(i) = mean(no_local_extremes(event_edge_indices(i,1):event_edge_indices(i,2)));
    local_extreme_rate_avg(i) = mean(local_extreme_rate(event_edge_indices(i,1):event_edge_indices(i,2)));
    no_local_max_avg(i) = mean(no_local_max(event_edge_indices(i,1):event_edge_indices(i,2)));
    local_max_rate_avg(i) = mean(local_max_rate(event_edge_indices(i,1):event_edge_indices(i,2)));
    no_local_min_avg(i) = mean(no_local_min(event_edge_indices(i,1):event_edge_indices(i,2)));
    local_min_rate_avg(i) = mean(local_min_rate(event_edge_indices(i,1):event_edge_indices(i,2)));
    mean_abs_dev_avg(i) = mean(mean_abs_dev(event_edge_indices(i,1):event_edge_indices(i,2)));
    diff_avg_avg(i) = mean(diff_avg(event_edge_indices(i,1):event_edge_indices(i,2)));
    std_dev_avg(i) = mean(std_dev(event_edge_indices(i,1):event_edge_indices(i,2)));
    min_freq_avg(i) = mean(min_freq(event_edge_indices(i,1):event_edge_indices(i,2)));
    max_freq_avg(i) = mean(max_freq(event_edge_indices(i,1):event_edge_indices(i,2)));
    freq_range_avg(i) = mean(freq_range(event_edge_indices(i,1):event_edge_indices(i,2)));
    abs_avg_avg(i) = mean(abs_avg(event_edge_indices(i,1):event_edge_indices(i,2)));
end


%%

zebra_stripe_classification = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 1]'; %index 1 through 96 (up until may threshold change)

no_vals_train = no_vals_avg(1:96)';
no_local_extremes_train = no_local_extremes_avg(1:96)';
local_extreme_rate_train = local_extreme_rate_avg(1:96)';
no_local_max_train = no_local_max_avg(1:96)';
local_max_rate_train = local_max_rate_avg(1:96)';
no_local_min_train = no_local_min_avg(1:96)';
local_min_rate_train = local_min_rate_avg(1:96)';
mean_abs_dev_train = mean_abs_dev_avg(1:96)';
diff_avg_train = diff_avg_avg(1:96)';
std_dev_train = std_dev_avg(1:96)';
min_freq_train = min_freq_avg(1:96)';
max_freq_train = max_freq_avg(1:96)';
freq_range_train = freq_range_avg(1:96)';
abs_avg_train = abs_avg_avg(1:96)';

trainingdata = table(zebra_stripe_classification,no_vals_train,no_local_extremes_train,local_extreme_rate_train,no_local_max_train,local_max_rate_train,no_local_min_train,local_min_rate_train,mean_abs_dev_train,diff_avg_train,std_dev_train,min_freq_train,max_freq_train,freq_range_train,abs_avg_train);

%%

%97 to 118 are to be ignored

zebra_stripe_classification = [1 0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0]'; %from 119 to 140

no_vals_train = no_vals_avg(119:140)';
no_local_extremes_train = no_local_extremes_avg(119:140)';
local_extreme_rate_train = local_extreme_rate_avg(119:140)';
no_local_max_train = no_local_max_avg(119:140)';
local_max_rate_train = local_max_rate_avg(119:140)';
no_local_min_train = no_local_min_avg(119:140)';
local_min_rate_train = local_min_rate_avg(119:140)';
mean_abs_dev_train = mean_abs_dev_avg(119:140)';
diff_avg_train = diff_avg_avg(119:140)';
std_dev_train = std_dev_avg(119:140)';
min_freq_train = min_freq_avg(119:140)';
max_freq_train = max_freq_avg(119:140)';
freq_range_train = freq_range_avg(119:140)';
abs_avg_train = abs_avg_avg(119:140)';

testdata = table(zebra_stripe_classification,no_vals_train,no_local_extremes_train,local_extreme_rate_train,no_local_max_train,local_max_rate_train,no_local_min_train,local_min_rate_train,mean_abs_dev_train,diff_avg_train,std_dev_train,min_freq_train,max_freq_train,freq_range_train,abs_avg_train);

%%

no_vals_train = no_vals_avg(141:1332)';
no_local_extremes_train = no_local_extremes_avg(141:1332)';
local_extreme_rate_train = local_extreme_rate_avg(141:1332)';
no_local_max_train = no_local_max_avg(141:1332)';
local_max_rate_train = local_max_rate_avg(141:1332)';
no_local_min_train = no_local_min_avg(141:1332)';
local_min_rate_train = local_min_rate_avg(141:1332)';
mean_abs_dev_train = mean_abs_dev_avg(141:1332)';
diff_avg_train = diff_avg_avg(141:1332)';
std_dev_train = std_dev_avg(141:1332)';
min_freq_train = min_freq_avg(141:1332)';
max_freq_train = max_freq_avg(141:1332)';
freq_range_train = freq_range_avg(141:1332)';
abs_avg_train = abs_avg_avg(141:1332)';

restofdata = table(no_vals_train,no_local_extremes_train,local_extreme_rate_train,no_local_max_train,local_max_rate_train,no_local_min_train,local_min_rate_train,mean_abs_dev_train,diff_avg_train,std_dev_train,min_freq_train,max_freq_train,freq_range_train,abs_avg_train);

%%

no_vals_train = no_vals_avg';
no_local_extremes_train = no_local_extremes_avg';
local_extreme_rate_train = local_extreme_rate_avg';
no_local_max_train = no_local_max_avg';
local_max_rate_train = local_max_rate_avg';
no_local_min_train = no_local_min_avg';
local_min_rate_train = local_min_rate_avg';
mean_abs_dev_train = mean_abs_dev_avg';
diff_avg_train = diff_avg_avg';
std_dev_train = std_dev_avg';
min_freq_train = min_freq_avg';
max_freq_train = max_freq_avg';
freq_range_train = freq_range_avg';
abs_avg_train = abs_avg_avg';

totaldata = table(no_vals_train,no_local_extremes_train,local_extreme_rate_train,no_local_max_train,local_max_rate_train,no_local_min_train,local_min_rate_train,mean_abs_dev_train,diff_avg_train,std_dev_train,min_freq_train,max_freq_train,freq_range_train,abs_avg_train);

%%

[model_classification,scores] = zebra_stripe_model.predictFcn(totaldata);
modeled_time = event_time(141:1332);
modeled_time_2 = event_time_edges(141:1332,:);

plot(event_time,model_classification,".")
ylim([-0.5 1.5])
yticks([0 1])
yticklabels(["No zebra stripes" "Zebra stripes"])
title("Inner Belt Passes With Zebra Stripes")
xlabel("Time")
ylabel("Modeled Pass Type")

%%
plot(event_time,model_classification,".")
ylim([-0.5 1.5])
xlim([datetime("2024-01-01") datetime("2024-01-31")])
yticks([0 1])
yticklabels(["No zebra stripes" "Zebra stripes"])
title("Inner Belt Passes With Zebra Stripes - January 2024")
xlabel("Time")
ylabel("Modeled Pass Type")

%%
class1 = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 1]'; %index 1 through 96 (up until may threshold change)
class2 = [1 0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0]'; %index 119 to 140

pass_labels = zeros(1332,1);
pass_labels(1:96,1) = class1;
pass_labels(97:118,1) = 0;
pass_labels(119:140,1) = class2;
pass_labels(141:1332,1) = model_classification;

%%

drift_indices = find(model_classification);


%%

channels = 1:45;
hold on
colormap(jet)
pcolor(time,channels,detrend_flux)
shading flat
xline(modeled_time)

%%
numtotal = length(find(pass_labels));


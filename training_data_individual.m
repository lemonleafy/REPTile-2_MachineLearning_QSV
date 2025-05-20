clear
clc

totaldata = struct2cell(load("zebra_stripes_data_totals.mat"));
detrend_flux = totaldata{1};
drift_freq = totaldata{2};
time = totaldata{3};
time = time(2:length(time));
event_edge_indices = load("event_edge_indices.mat");

for i = 1:length(time)
    indexes = find(~isnan(detrend_flux(:,i)));
    maxindex = max(indexes);
    if (sum(detrend_flux(maxindex-2:maxindex,i))<0)
        detrend_flux(maxindex-2:maxindex,i) = nan;
        drift_freq(maxindex-2:maxindex,i) = nan;
    end
end

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
peak_rate = [];


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
    peak_rate(i) = length(find(abs(detrend_flux(:,i))>0.2))/no_vals(i);
end

%%

training_times = NaT();
zebra_stripe_classification = [];
no_vals_train = [];
no_local_extremes_train = [];
local_extreme_rate_train = [];
no_local_max_train = [];
local_max_rate_train = [];
no_local_min_train = [];
local_min_rate_train = [];
mean_abs_dev_train = [];
diff_avg_train = [];
std_dev_train = [];
min_freq_train = [];
max_freq_train = [];
freq_range_train = [];
abs_avg_train = [];
peak_rate_train = [];

%%

class1 = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 1]';

%%

zebra_stripe_classification(1:141) = 1;
training_times(1:141) = time(406:546);
no_vals_train(1:141) = no_vals(406:546);
no_local_extremes_train(1:141) = no_local_extremes(406:546);
local_extreme_rate_train(1:141) = local_extreme_rate(406:546);
no_local_max_train(1:141) = no_local_max(406:546);
local_max_rate_train(1:141) = local_max_rate(406:546);
no_local_min_train(1:141) = no_local_min(406:546);
local_min_rate_train(1:141) = local_min_rate(406:546);
mean_abs_dev_train(1:141) = mean_abs_dev(406:546);
diff_avg_train(1:141) = diff_avg(406:546);
std_dev_train(1:141) = std_dev(406:546);
min_freq_train(1:141) = min_freq(406:546);
max_freq_train(1:141) = max_freq(406:546);
freq_range_train(1:141) = freq_range(406:546);
abs_avg_train(1:141) = abs_avg(406:546);
peak_rate_train(1:141) = peak_rate(406:546);

zebra_stripe_classification(142:250) = 1;
training_times(142:250) = time(866:974);
no_vals_train(142:250) = no_vals(866:974);
no_local_extremes_train(142:250) = no_local_extremes(866:974);
local_extreme_rate_train(142:250) = local_extreme_rate(866:974);
no_local_max_train(142:250) = no_local_max(866:974);
local_max_rate_train(142:250) = local_max_rate(866:974);
no_local_min_train(142:250) = no_local_min(866:974);
local_min_rate_train(142:250) = local_min_rate(866:974);
mean_abs_dev_train(142:250) = mean_abs_dev(866:974);
diff_avg_train(142:250) = diff_avg(866:974);
std_dev_train(142:250) = std_dev(866:974);
min_freq_train(142:250) = min_freq(866:974);
max_freq_train(142:250) = max_freq(866:974);
freq_range_train(142:250) = freq_range(866:974);
abs_avg_train(142:250) = abs_avg(866:974);
peak_rate_train(142:250) = peak_rate(866:974);

zebra_stripe_classification(251:387) = 1;
training_times(251:387) = time(8099:8235);
no_vals_train(251:387) = no_vals(8099:8235);
no_local_extremes_train(251:387) = no_local_extremes(8099:8235);
local_extreme_rate_train(251:387) = local_extreme_rate(8099:8235);
no_local_max_train(251:387) = no_local_max(8099:8235);
local_max_rate_train(251:387) = local_max_rate(8099:8235);
no_local_min_train(251:387) = no_local_min(8099:8235);
local_min_rate_train(251:387) = local_min_rate(8099:8235);
mean_abs_dev_train(251:387) = mean_abs_dev(8099:8235);
diff_avg_train(251:387) = diff_avg(8099:8235);
std_dev_train(251:387) = std_dev(8099:8235);
min_freq_train(251:387) = min_freq(8099:8235);
max_freq_train(251:387) = max_freq(8099:8235);
freq_range_train(251:387) = freq_range(8099:8235);
abs_avg_train(251:387) = abs_avg(8099:8235);
peak_rate_train(251:387) = peak_rate(8099:8235);

zebra_stripe_classification(388:739) = 1;
training_times(388:739) = time(8533:8884);
no_vals_train(388:739) = no_vals(8533:8884);
no_local_extremes_train(388:739) = no_local_extremes(8533:8884);
local_extreme_rate_train(388:739) = local_extreme_rate(8533:8884);
no_local_max_train(388:739) = no_local_max(8533:8884);
local_max_rate_train(388:739) = local_max_rate(8533:8884);
no_local_min_train(388:739) = no_local_min(8533:8884);
local_min_rate_train(388:739) = local_min_rate(8533:8884);
mean_abs_dev_train(388:739) = mean_abs_dev(8533:8884);
diff_avg_train(388:739) = diff_avg(8533:8884);
std_dev_train(388:739) = std_dev(8533:8884);
min_freq_train(388:739) = min_freq(8533:8884);
max_freq_train(388:739) = max_freq(8533:8884);
freq_range_train(388:739) = freq_range(8533:8884);
abs_avg_train(388:739) = abs_avg(8533:8884);
peak_rate_train(388:739) = peak_rate(8533:8884);

zebra_stripe_classification(740:972) = 1;
training_times(740:972) = time(9164:9396);
no_vals_train(740:972) = no_vals(9164:9396);
no_local_extremes_train(740:972) = no_local_extremes(9164:9396);
local_extreme_rate_train(740:972) = local_extreme_rate(9164:9396);
no_local_max_train(740:972) = no_local_max(9164:9396);
local_max_rate_train(740:972) = local_max_rate(9164:9396);
no_local_min_train(740:972) = no_local_min(9164:9396);
local_min_rate_train(740:972) = local_min_rate(9164:9396);
mean_abs_dev_train(740:972) = mean_abs_dev(9164:9396);
diff_avg_train(740:972) = diff_avg(9164:9396);
std_dev_train(740:972) = std_dev(9164:9396);
min_freq_train(740:972) = min_freq(9164:9396);
max_freq_train(740:972) = max_freq(9164:9396);
freq_range_train(740:972) = freq_range(9164:9396);
abs_avg_train(740:972) = abs_avg(9164:9396);
peak_rate_train(740:972) = peak_rate(9164:9396);

zebra_stripe_classification(973:1208) = 0;
training_times(973:1208) = time(4216:4451);
no_vals_train(973:1208) = no_vals(4216:4451);
no_local_extremes_train(973:1208) = no_local_extremes(4216:4451);
local_extreme_rate_train(973:1208) = local_extreme_rate(4216:4451);
no_local_max_train(973:1208) = no_local_max(4216:4451);
local_max_rate_train(973:1208) = local_max_rate(4216:4451);
no_local_min_train(973:1208) = no_local_min(4216:4451);
local_min_rate_train(973:1208) = local_min_rate(4216:4451);
mean_abs_dev_train(973:1208) = mean_abs_dev(4216:4451);
diff_avg_train(973:1208) = diff_avg(4216:4451);
std_dev_train(973:1208) = std_dev(4216:4451);
min_freq_train(973:1208) = min_freq(4216:4451);
max_freq_train(973:1208) = max_freq(4216:4451);
freq_range_train(973:1208) = freq_range(4216:4451);
abs_avg_train(973:1208) = abs_avg(4216:4451);
peak_rate_train(973:1208) = peak_rate(4216:4451);

zebra_stripe_classification(1209:1348) = 0;
training_times(1209:1348) = time(2904:3043);
no_vals_train(1209:1348) = no_vals(2904:3043);
no_local_extremes_train(1209:1348) = no_local_extremes(2904:3043);
local_extreme_rate_train(1209:1348) = local_extreme_rate(2904:3043);
no_local_max_train(1209:1348) = no_local_max(2904:3043);
local_max_rate_train(1209:1348) = local_max_rate(2904:3043);
no_local_min_train(1209:1348) = no_local_min(2904:3043);
local_min_rate_train(1209:1348) = local_min_rate(2904:3043);
mean_abs_dev_train(1209:1348) = mean_abs_dev(2904:3043);
diff_avg_train(1209:1348) = diff_avg(2904:3043);
std_dev_train(1209:1348) = std_dev(2904:3043);
min_freq_train(1209:1348) = min_freq(2904:3043);
max_freq_train(1209:1348) = max_freq(2904:3043);
freq_range_train(1209:1348) = freq_range(2904:3043);
abs_avg_train(1209:1348) = abs_avg(2904:3043);
peak_rate_train(1209:1348) = peak_rate(2904:3043);

zebra_stripe_classification(1349:1692) = 0;
training_times(1349:1692) = time(23130:23473);
no_vals_train(1349:1692) = no_vals(23130:23473);
no_local_extremes_train(1349:1692) = no_local_extremes(23130:23473);
local_extreme_rate_train(1349:1692) = local_extreme_rate(23130:23473);
no_local_max_train(1349:1692) = no_local_max(23130:23473);
local_max_rate_train(1349:1692) = local_max_rate(23130:23473);
no_local_min_train(1349:1692) = no_local_min(23130:23473);
local_min_rate_train(1349:1692) = local_min_rate(23130:23473);
mean_abs_dev_train(1349:1692) = mean_abs_dev(23130:23473);
diff_avg_train(1349:1692) = diff_avg(23130:23473);
std_dev_train(1349:1692) = std_dev(23130:23473);
min_freq_train(1349:1692) = min_freq(23130:23473);
max_freq_train(1349:1692) = max_freq(23130:23473);
freq_range_train(1349:1692) = freq_range(23130:23473);
abs_avg_train(1349:1692) = abs_avg(23130:23473);
peak_rate_train(1349:1692) = peak_rate(23130:23473);

zebra_stripe_classification(1693:1872) = 0;
training_times(1693:1872) = time(19411:19590);
no_vals_train(1693:1872) = no_vals(19411:19590);
no_local_extremes_train(1693:1872) = no_local_extremes(19411:19590);
local_extreme_rate_train(1693:1872) = local_extreme_rate(19411:19590);
no_local_max_train(1693:1872) = no_local_max(19411:19590);
local_max_rate_train(1693:1872) = local_max_rate(19411:19590);
no_local_min_train(1693:1872) = no_local_min(19411:19590);
local_min_rate_train(1693:1872) = local_min_rate(19411:19590);
mean_abs_dev_train(1693:1872) = mean_abs_dev(19411:19590);
diff_avg_train(1693:1872) = diff_avg(19411:19590);
std_dev_train(1693:1872) = std_dev(19411:19590);
min_freq_train(1693:1872) = min_freq(19411:19590);
max_freq_train(1693:1872) = max_freq(19411:19590);
freq_range_train(1693:1872) = freq_range(19411:19590);
abs_avg_train(1693:1872) = abs_avg(19411:19590);
peak_rate_train(1693:1872) = peak_rate(19411:19590);

zebra_stripe_classification(1873:2101) = 0;
training_times(1873:2101) = time(20736:20964);
no_vals_train(1873:2101) = no_vals(20736:20964);
no_local_extremes_train(1873:2101) = no_local_extremes(20736:20964);
local_extreme_rate_train(1873:2101) = local_extreme_rate(20736:20964);
no_local_max_train(1873:2101) = no_local_max(20736:20964);
local_max_rate_train(1873:2101) = local_max_rate(20736:20964);
no_local_min_train(1873:2101) = no_local_min(20736:20964);
local_min_rate_train(1873:2101) = local_min_rate(20736:20964);
mean_abs_dev_train(1873:2101) = mean_abs_dev(20736:20964);
diff_avg_train(1873:2101) = diff_avg(20736:20964);
std_dev_train(1873:2101) = std_dev(20736:20964);
min_freq_train(1873:2101) = min_freq(20736:20964);
max_freq_train(1873:2101) = max_freq(20736:20964);
freq_range_train(1873:2101) = freq_range(20736:20964);
abs_avg_train(1873:2101) = abs_avg(20736:20964);
peak_rate_train(1873:2101) = peak_rate(20736:20964);

%%

zebra_stripe_classification = zebra_stripe_classification';
no_vals_train = no_vals_train';
no_local_extremes_train = no_local_extremes_train';
local_extreme_rate_train = local_extreme_rate_train';
no_local_max_train = no_local_max_train';
local_max_rate_train = local_max_rate_train';
no_local_min_train = no_local_min_train';
local_min_rate_train = local_min_rate_train';
mean_abs_dev_train = mean_abs_dev_train';
diff_avg_train = diff_avg_train';
std_dev_train = std_dev_train';
min_freq_train = min_freq_train';
max_freq_train = max_freq_train';
freq_range_train = freq_range_train';
abs_avg_train = abs_avg_train';
peak_rate_train = peak_rate_train';

%%

trainingdata = table(zebra_stripe_classification,no_vals_train,no_local_extremes_train,local_extreme_rate_train,no_local_max_train,local_max_rate_train,no_local_min_train,local_min_rate_train,mean_abs_dev_train,diff_avg_train,std_dev_train,min_freq_train,max_freq_train,freq_range_train,abs_avg_train,peak_rate_train);

%%

zebra_stripe_classification(1:164) = 1;
training_times(1:164) = time(39121:39284);
no_vals_train(1:164) = no_vals(39121:39284);
no_local_extremes_train(1:164) = no_local_extremes(39121:39284);
local_extreme_rate_train(1:164) = local_extreme_rate(39121:39284);
no_local_max_train(1:164) = no_local_max(39121:39284);
local_max_rate_train(1:164) = local_max_rate(39121:39284);
no_local_min_train(1:164) = no_local_min(39121:39284);
local_min_rate_train(1:164) = local_min_rate(39121:39284);
mean_abs_dev_train(1:164) = mean_abs_dev(39121:39284);
diff_avg_train(1:164) = diff_avg(39121:39284);
std_dev_train(1:164) = std_dev(39121:39284);
min_freq_train(1:164) = min_freq(39121:39284);
max_freq_train(1:164) = max_freq(39121:39284);
freq_range_train(1:164) = freq_range(39121:39284);
abs_avg_train(1:164) = abs_avg(39121:39284);
peak_rate_train(1:164) = peak_rate(39121:39284);

zebra_stripe_classification(165:340) = 1;
training_times(165:340) = time(40820:40995);
no_vals_train(165:340) = no_vals(40820:40995);
no_local_extremes_train(165:340) = no_local_extremes(40820:40995);
local_extreme_rate_train(165:340) = local_extreme_rate(40820:40995);
no_local_max_train(165:340) = no_local_max(40820:40995);
local_max_rate_train(165:340) = local_max_rate(40820:40995);
no_local_min_train(165:340) = no_local_min(40820:40995);
local_min_rate_train(165:340) = local_min_rate(40820:40995);
mean_abs_dev_train(165:340) = mean_abs_dev(40820:40995);
diff_avg_train(165:340) = diff_avg(40820:40995);
std_dev_train(165:340) = std_dev(40820:40995);
min_freq_train(165:340) = min_freq(40820:40995);
max_freq_train(165:340) = max_freq(40820:40995);
freq_range_train(165:340) = freq_range(40820:40995);
abs_avg_train(165:340) = abs_avg(40820:40995);
peak_rate_train(165:340) = peak_rate(40820:40995);

zebra_stripe_classification(341:512) = 0;
training_times(341:512) = time(40271:40442);
no_vals_train(341:512) = no_vals(40271:40442);
no_local_extremes_train(341:512) = no_local_extremes(40271:40442);
local_extreme_rate_train(341:512) = local_extreme_rate(40271:40442);
no_local_max_train(341:512) = no_local_max(40271:40442);
local_max_rate_train(341:512) = local_max_rate(40271:40442);
no_local_min_train(341:512) = no_local_min(40271:40442);
local_min_rate_train(341:512) = local_min_rate(40271:40442);
mean_abs_dev_train(341:512) = mean_abs_dev(40271:40442);
diff_avg_train(341:512) = diff_avg(40271:40442);
std_dev_train(341:512) = std_dev(40271:40442);
min_freq_train(341:512) = min_freq(40271:40442);
max_freq_train(341:512) = max_freq(40271:40442);
freq_range_train(341:512) = freq_range(40271:40442);
abs_avg_train(341:512) = abs_avg(40271:40442);
peak_rate_train(341:512) = peak_rate(40271:40442);

zebra_stripe_classification(513:726) = 0;
training_times(513:726) = time(42503:42716);
no_vals_train(513:726) = no_vals(42503:42716);
no_local_extremes_train(513:726) = no_local_extremes(42503:42716);
local_extreme_rate_train(513:726) = local_extreme_rate(42503:42716);
no_local_max_train(513:726) = no_local_max(42503:42716);
local_max_rate_train(513:726) = local_max_rate(42503:42716);
no_local_min_train(513:726) = no_local_min(42503:42716);
local_min_rate_train(513:726) = local_min_rate(42503:42716);
mean_abs_dev_train(513:726) = mean_abs_dev(42503:42716);
diff_avg_train(513:726) = diff_avg(42503:42716);
std_dev_train(513:726) = std_dev(42503:42716);
min_freq_train(513:726) = min_freq(42503:42716);
max_freq_train(513:726) = max_freq(42503:42716);
freq_range_train(513:726) = freq_range(42503:42716);
abs_avg_train(513:726) = abs_avg(42503:42716);
peak_rate_train(513:726) = peak_rate(42503:42716);

%%

zebra_stripe_classification = zebra_stripe_classification';
no_vals_train = no_vals_train';
no_local_extremes_train = no_local_extremes_train';
local_extreme_rate_train = local_extreme_rate_train';
no_local_max_train = no_local_max_train';
local_max_rate_train = local_max_rate_train';
no_local_min_train = no_local_min_train';
local_min_rate_train = local_min_rate_train';
mean_abs_dev_train = mean_abs_dev_train';
diff_avg_train = diff_avg_train';
std_dev_train = std_dev_train';
min_freq_train = min_freq_train';
max_freq_train = max_freq_train';
freq_range_train = freq_range_train';
abs_avg_train = abs_avg_train';
peak_rate_train = peak_rate_train';

testdata = table(zebra_stripe_classification,no_vals_train,no_local_extremes_train,local_extreme_rate_train,no_local_max_train,local_max_rate_train,no_local_min_train,local_min_rate_train,mean_abs_dev_train,diff_avg_train,std_dev_train,min_freq_train,max_freq_train,freq_range_train,abs_avg_train,peak_rate_train);

%%

no_vals_train = no_vals';
no_local_extremes_train = no_local_extremes';
local_extreme_rate_train = local_extreme_rate';
no_local_max_train = no_local_max';
local_max_rate_train = local_max_rate';
no_local_min_train = no_local_min';
local_min_rate_train = local_min_rate';
mean_abs_dev_train = mean_abs_dev';
diff_avg_train = diff_avg';
std_dev_train = std_dev';
min_freq_train = min_freq';
max_freq_train = max_freq';
freq_range_train = freq_range';
abs_avg_train = abs_avg';
peak_rate_train = peak_rate';

totaldata = table(no_vals_train,no_local_extremes_train,local_extreme_rate_train,no_local_max_train,local_max_rate_train,no_local_min_train,local_min_rate_train,mean_abs_dev_train,diff_avg_train,std_dev_train,min_freq_train,max_freq_train,freq_range_train,abs_avg_train,peak_rate_train);

%%

[model_classification,scores] = zebra_stripe_individual_model.predictFcn(totaldata);

%%

totalnum = length(find(model_classification));
percent = (totalnum/length(model_classification))*100;
plot_model = model_classification.*40;
plot_model = plot_model+5;

%%                                                    

channels = 6:50;

subplot(2,1,1)
hold on
colormap(jet)
pcolor(time,channels,detrend_flux)
scatter(time,plot_model,4,"filled")
shading flat
%c = colorbar;
clim([-1 1]) 
ylim([4 50])
xlim(event_time_edges(1107,:))
ylabel("Energy Channel")
hold off

subplot(2,1,2)
hold on
%plot(time,scores(:,1))
plot(time,scores(:,2))
xlim(event_time_edges(1107,:))
yline(0)
ylim([-10 10])
ylabel("Score")
hold off



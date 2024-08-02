
%% Extended Figure 1 - HBE1 cells' ERK response to bulk and single cytokine conditions

% add paths
addpath('Z:\Code\Nick','Z:\Code\Cell Trace','Z:\Code\Image Analysis')

basePath = 'Z:\Processed Data\SPREADs\';
pars = {'Responder','Delta_Mean','Frequency','Mean_Dur','tracklength','Responder_Dur'}; % parameters to collect

%% Load the data from multiple experiments to be pooled together

% ERKTR Data
%
% 2020-11-30 HBE1 ERKTR
% All cytokine groups and il6
figE1{1} = [basePath,'2020-11-30 HBE1 AMPKAR ERKTR Cytokine Array Stat test\2020-11-30 HBE1 AMPKAR ERKTR Cytokine Array Stat test_Processed_Copy.mat'];

% 2021-01-25 HBE1 ERKTR
% All cytokine groups and il6
figE1{2} = [basePath,'2021-01-25 HBE1 AMPKAR ERKTR Cytokine Array\2021-01-25 HBE1 AMPKAR ERKTR Cytokine Array_Processed_Copy.mat'];

% 2021-07-28 HBE1 ERKTR
% IL1b, IL6, EGF, Vehicle, LPS, 
figE1{3} = [basePath,'2021-07-28 HBE1 AMPKAR ERKTR Cytokine INS OLI 2DG\2021-07-28 HBE1 AMPKAR ERKTR Cytokine INS OLI 2DG_Processed_Copy.mat'];

% pull ERKTR pulse analysis from the HBE1 data
[paDFa]= convertPulseToDataframe(figE1,{'ERKTR'},'aftertx',2,'tmaxaftertx',24,'pulsepars',pars,'responderdelta',0.3,'respondermaxtx',0.5,'addchannelname',false,'minlength',12,'exclude',{'oli','twodg','simvastatin','NOINS'}); % was 8 hrs

% simplify the naming
paDFa.treatment = strrep(paDFa.treatment,' at hour 0',''); % remove the "at hour 0" from the treatment names for better labeling
paDFa.treatment = strrep(paDFa.treatment,'1 fim at hour -4 and ',''); % remove the "at hour 0" from the treatment names for better labeling
paDFa.treatment = strrep(paDFa.treatment,'1 fim at hour -18 and ',''); % remove the "at hour 0" from the treatment names for better labeling

% EKAR Data
%
% 2023-09-06 HBE1 EKAREN4
% IFNy/TNFa, IL1/6/TNF, IL1b, IL6, EGF, Vehicle, POLYIC, INF
% subset fim
% exclude TwoDG, 
figE12{1} = [basePath,'2023-09-06 HBE1 EKAREN4 Cyto INS HC 2DG\2023-09-06 HBE1 EKAREN4 Cyto INS HC 2DG_Processed_Copy.mat'];

% Run 3 - 2023-09-28 HBE1 EKAR
% All cytokine groups and il1b, il6, tnfa, ifny singles
figE12{2} = [basePath,'2023-09-28 HBE1 EKAREN4 Cytokine Array\2023-09-28 HBE1 EKAREN4 Cytokine Array_Processed_Copy.mat'];

% pull EKAR pulse analysis from the HBE1 data
[paDFb] = convertPulseToDataframe(figE12,{'EKAR'},'aftertx',2,'tmaxaftertx',24,'pulsepars',pars,'responderdelta',0.05,'respondermaxtx',0.5,'addchannelname',false,'minlength',12,'exclude',{'oli','twodg','simvastatin','NOINS','NOHC'}); %'exclude',{'IL620n','TNFa20n','Simvastatin'}
paDFb.treatment = strrep(paDFb.treatment,' at hour 0',''); % remove the "at hour 0" from the treatment names for better labeling
paDFb.treatment = strrep(paDFb.treatment,'1 fim at hour -16 and ',''); % remove the "at hour 0" from the treatment names for better labeling

%% Merged the loaded data, put them in order, and get general information about the data

% Combine the ERK-KTR and EKAR data 
paDF2 = [paDFa; paDFb];

paDF = paDF2; % make a copy of the data for manipulation

% Exclude treatments we don't indend to plot
keepD = any([contains(paDF.treatment," and "|"10ng/mL EGF"),~contains(paDF.treatment,'10ng/mL')],2);
paDF = paDF(keepD,:);
paDF = paDF(~contains(paDF.treatment,{'1ng/mL','EGF at hour -2'}),:);
paDF = paDF(~matches(paDF.treatment,'10ng/mL IL13 and 10ng/mL IL4 and 10ng/mL IL5'),:);

% make treatments a categorical but keep the order the data is in
txOrder = {'1 vehicle','10ng/mL EGF','10ng/mL IL1b and 10ng/mL IL6 and 10ng/mL TNFa','20ng/mL IL1b','20ng/mL IL6',...
    '20ng/mL TNFa','10ng/mL IFNy and 10ng/mL TNFa','20ng/mL IFNy','10ng/mL IL13 and 10ng/mL IL4 and 10ng/mL IL5 and 10ng/mL IL9',...
    '10ng/mL IL17a and 10ng/mL IL23','20ug/mL LPS','20ug/mL PolyIC'};
paDF.treatment = categorical(paDF.treatment,txOrder);

% get the statistical data
figE1Stats = grpstats(paDF, "treatment",["mean","median","sem","std"],"DataVars",["Frequency","Mean_Dur","Delta_Mean","Responder_Dur"]);

% Convert Responder Duration to minutes (from hours) to make it easier when writing
figE1Stats.mean_Responder_Dur_in_min = figE1Stats.mean_Responder_Dur*60

% do 1way anova of duration of response compared to EGF
[~,~,stats] = anova1(paDF.Responder_Dur,paDF.treatment,'off');
[results,~,~,gnames] = multcompare(stats,"CriticalValueType","dunnett",'ControlGroup',find(matches(stats.gnames,'1 vehicle')),'Display','off','Approximate',false); 
ERKtxResponderStats = array2table(results,"VariableNames", ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
ERKtxResponderStats.("Group") = gnames(ERKtxResponderStats.("Group"));
ERKtxResponderStats.("Control Group") = gnames(ERKtxResponderStats.("Control Group"))

% get the mean of the pulse durations (in minutes)
meanPulseDurAllTxs = mean(figE1Stats.mean_Mean_Dur)*60

%% Do the statistics on percent HBE1 cells ERK response to treatments (and plot it) For Figure E1A
% pull the subset of data that has reponder data (is not nan)
responderz = paDF(~isnan(paDF.Responder),:);

% Calculate the count of all entries per treatment group
totalCount = groupsummary(responderz,'treatment');

% Calculate the count of responders (true) per treatment group
responderCount = groupsummary(responderz(responderz.Responder==1,:), 'treatment');

% Calculate the percentage of responders for each treatment group
percResponders = join(responderCount,totalCount,'Keys','treatment');
percResponders.PercResponders = (percResponders.GroupCount_responderCount ./ percResponders.GroupCount_totalCount) * 100

% Make the % responders bar graph
percFig = figure;
y = bar(percResponders.treatment,percResponders.PercResponders,'LineWidth',1);
xlabel('Treatment'); ylabel('% ERK responders to treatment'); % add labels and set font sizes

% maybe add number of cells that went into the % caculations?
ytips = y.YEndPoints;
labels1 = string(percResponders.GroupCount_totalCount);
labels1 = strcat("n = ", labels1);
text(percResponders.treatment,ytips,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

% assert font style and size
fontname(percFig,"Arial"); fontsize(percFig,4,'points'); ylim([0,110]);

% set the figure to inches
percFig.Units = "inches";

%% Do the statistics on each cell's mean ERK pulse frequency by treatment (and plot it) For Figure E1B
figure;
boxchart(paDF.treatment,paDF.Frequency,'Notch','on','JitterOutliers','on','MarkerStyle','None','LineWidth',1);
xlabel('Treatment'); ylabel('ERK Pulse Frequency per cell'); % add labels and set font sizes
fontname(gcf,"Arial"); fontsize(gcf,4,'points');
ylim([0,1])

% do 1way anova of frequency compared to the control
[~,~,stats] = anova1(paDF.Frequency,paDF.treatment,'off');
[results,~,~,gnames] = multcompare(stats,"CriticalValueType","dunnett",'ControlGroup',find(matches(stats.gnames,'1 vehicle')),'Display','off','Approximate',false); 
ERKpulseFreqStats = array2table(results,"VariableNames", ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
ERKpulseFreqStats.("Group") = gnames(ERKpulseFreqStats.("Group"));
ERKpulseFreqStats.("Control Group") = gnames(ERKpulseFreqStats.("Control Group"))

%% Do the statistics on each cell's mean ERK pulse duration by treatment (and plot it) For Figure E1C
figure;
boxchart(paDF.treatment,paDF.Mean_Dur*60,'Notch','on','JitterOutliers','on','MarkerStyle','None','LineWidth',1);
xlabel('Treatment'); ylabel('ERK pulse duration in minutes (average duration per cell)'); % add labels and set font sizes
fontname(gcf,"Arial"); fontsize(gcf,4,'points'); ylim([0,70])

% do 1way anova of mean pulse duration compared to the control
[~,~,stats] = anova1(paDF.Mean_Dur,paDF.treatment,'off');
[results,~,~,gnames] = multcompare(stats,"CriticalValueType","dunnett",'ControlGroup',find(matches(stats.gnames,'1 vehicle')),'Display','off','Approximate',false); 
ERKpulseDurStats = array2table(results,"VariableNames", ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
ERKpulseDurStats.("Group") = gnames(ERKpulseDurStats.("Group"));
ERKpulseDurStats.("Control Group") = gnames(ERKpulseDurStats.("Control Group"))

%% Make the final version of the Figure E1
figE1 = figure;

% plot percent responders
subplot(3,1,1);
bar(percResponders.treatment,percResponders.PercResponders,'LineWidth',1);
ylabel('% ERK responders to treatment'); % add labels and set font sizes
ylim([0,110]); xticklabels({});

% plot ERK pulse frequency
subplot(3,1,2);
boxchart(paDF.treatment,paDF.Frequency,'Notch','on','JitterOutliers','on','MarkerStyle','None','LineWidth',1);
ylabel('ERK Pulse Frequency per cell'); % add labels and set font sizes
ylim([0,0.9]); xticklabels({});

% plot ERK pulse duration
subplot(3,1,3);
boxchart(paDF.treatment,paDF.Mean_Dur*60,'Notch','on','JitterOutliers','on','MarkerStyle','None','LineWidth',1);
xlabel('Treatment'); ylabel('Cell mean ERK pulse duration (minutes)'); % add labels and set font sizes
ylim([0,70]);

xticklabels({'vehicle','EGF','IL1b/IL6/TNFa','IL1b','IL6',...
    'TNFa','IFNy/TNFa','IFNy','IL4/5/9/13',...
    'IL17a/IL23','LPS','PolyIC'});

% Standardize the figure fonts and sizes
fontname(gcf,"Arial"); fontsize(gcf,8,'points');
a = gcf;
a.Units ="inches";
a.Position = [0.5,0.5,8.5,11];

ax = get(a, 'children');
ax(1).Units = 'Inches'; ax(2).Units = 'Inches'; ax(3).Units = 'Inches';
ax(1).InnerPosition = [2,1,4.5,2.5]; ax(2).InnerPosition = [2,3.75,4.5,2.5]; ax(3).InnerPosition = [2,6.5,4.5,2.5];

saveas(figE1,'Z:\imageData\SPREADs\Plotting_Code\Figure_Outputs\E1_HBE1_ERK_Pulse.fig')
saveas(figE1,'Z:\imageData\SPREADs\Plotting_Code\Figure_Outputs\E1_HBE1_ERK_Pulse.svg')


%% Figure Legend:
% Figure E1. Quantification of ERK activity in HBE1 cells in response to pro-inflammatory ligands and controls. 
% (A) The percentage of cells that respond to respective treatments. Responders were defined as cells that 
% increase in ERK-KTR or EKAREN4 signal by 0.3, or 0.05 A.U., respectively, after treatment, relative to mean 
% activity 1 hour before treatment. (B) Notched box plots of ERK pulse frequency over 24 hours following 
% treatment (occurrences of ERK activation per cell per hour) for each condition. Plots represent the median 
% (line at center of notch), 95% confidence interval of the mean (notch), interquartile range 
% (25th/75th percentile, blue box), and range of data excluding outliers (whiskers). (C) Notched box plots 
% showing each cell%s average ERK pulse duration (in minutes). Data for A-C is cumulative from 5 experimental 
% replicates, with >7,500 cells per condition.
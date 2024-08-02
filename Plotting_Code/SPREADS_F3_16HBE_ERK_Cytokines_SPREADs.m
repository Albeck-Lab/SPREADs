%% Figure 3 - 16HBE cells

% Figure 3 A-G and Figure E4 A-K
% Cytokine treatment groups and Single Cytokine treatment plots
% Mean and Heatmap plots are from 2023-10-14 16HBE14 EKAR Cytokine Array experiment
% For Heatmaps - A random 100 of the longest ERK tracks from each condition were plotted
%

% add the paths
addpath('Z:\Code\Nick','Z:\Code\Cell Trace','Z:\Code\Image Analysis','Z:\Code\ARCOS-MATLAB\Source')

% add the base folder for all data
baseFold = 'Z:\Processed Data\SPREADs\';

% Extra Info - 16HBE ERK response

% 2023-08-09 16HBE14
fig3{1} = [baseFold, '2023-08-09 16hbe14 EKAR Cyto Gef Toc\2023-08-09 16hbe14 EKAR Cyto Gef Toc_Processed.mat'];

% 2023-10-14 16HBE14
fig3{2} = [baseFold, '2023-10-14 16HBE14 EKAR Cytokine Array\2023-10-14 16HBE14 EKAR Cytokine Array_Processed.mat'];

% pull pulse analysis from the data
pars = {'Responder','Delta_Mean','Frequency','Mean_Dur','DurFirstP'}; % parameters to collect
expar = {'Cell','Tx1','Tx2'}; % treatments to consider
paDF = convertPulseToDataframe(fig3,{'EKAR'},'aftertx',2,'tmaxaftertx',24,'pulsepars',pars,'expar',expar,'exclude',{'Simvastatin','Gef','Toc','PD','ERKi'},'responderdelta',0.07,'respondermaxtx',0.5);
paDF.treatment = strrep(paDF.treatment,' at hour 0',''); % remove the "at hour 0" from the treatment names for better labeling

% make treatments a categorical but keep the order the data is in
txs = unique(paDF.treatment,'stable'); paDF.treatment = categorical(paDF.treatment,txs);

% get the statistical data
fig4Stats = grpstats(paDF, "treatment",["mean","median","sem","std"],"DataVars",["EKAR_Frequency","EKAR_Mean_Dur","EKAR_DurFirstP"])

%% Extra Info Part 2: plot percent of 16HBE ERK responders by treatment

%pull the subset of data that has reponder data (is not nan)
responderz = paDF(~isnan(paDF.EKAR_Responder),:);

% Calculate the count of all entries per treatment group
totalCount = groupsummary(responderz,'treatment');

% Calculate the count of responders (true) per treatment group
responderCount = groupsummary(responderz(responderz.EKAR_Responder==1,:), 'treatment');

% Calculate the percentage of responders for each treatment group
percResponders = join(responderCount,totalCount,'Keys','treatment');
percResponders.PercResponders = (percResponders.GroupCount_responderCount ./ percResponders.GroupCount_totalCount) * 100;

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
fontname(percFig,"Arial"); fontsize(percFig,8,'points'); ylim([0,110]);

% set the figure to inches
percFig.Units = "inches";

%% Extra Info Part 2: plot duration of 16HBE ERK response by treatment
figure;
boxchart(paDF.treatment,paDF.EKAR_Frequency,'Notch','on','JitterOutliers','on','MarkerStyle','None','LineWidth',1);
xlabel('Treatment'); ylabel('ERK Pulse Frequency per cell'); % add labels and set font sizes
fontname(gcf,"Arial"); fontsize(gcf,8,'points');

% do 1way anova of frequency compared to the control
[~,~,stats] = anova1(paDF.EKAR_Frequency,paDF.treatment,'off');
[results,~,~,gnames] = multcompare(stats,"CriticalValueType","dunnett",'ControlGroup',find(contains(stats.gnames,'1 vehicle')),'Display','off'); 
ERKpulseFreqStats = array2table(results,"VariableNames", ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
ERKpulseFreqStats.("Group") = gnames(ERKpulseFreqStats.("Group"));
ERKpulseFreqStats.("Control Group") = gnames(ERKpulseFreqStats.("Control Group"));

%% Extra Info Part 3: plot the frequency of 16HBE ERK pulses by treatment
figure;
boxchart(paDF.treatment,paDF.EKAR_Frequency,'Notch','on','JitterOutliers','on','MarkerStyle','None','LineWidth',1);
xlabel('Treatment'); ylabel('ERK Pulse Frequency per cell'); % add labels and set font sizes
fontname(gcf,"Arial"); fontsize(gcf,8,'points'); ylim([0,1.25]);

% do 1way anova of frequency compared to the control
[~,~,stats] = anova1(paDF.EKAR_Frequency,paDF.treatment,'off');
[results,~,~,gnames] = multcompare(stats,"CriticalValueType","dunnett",'ControlGroup',find(contains(gnames,'1 vehicle')),'Display','off'); 
ERKpulseFreqStats = array2table(results,"VariableNames", ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
ERKpulseFreqStats.("Group") = gnames(ERKpulseFreqStats.("Group"));
ERKpulseFreqStats.("Control Group") = gnames(ERKpulseFreqStats.("Control Group"));

%% Extra Info Part 4: plot each 16HBE cell's mean ERK pulse duration by treatment
figure;
boxchart(paDF.treatment,paDF.EKAR_Mean_Dur*60,'Notch','on','JitterOutliers','on','MarkerStyle','None','LineWidth',1);
xlabel('Treatment'); ylabel('ERK pulse duration in minutes (average duration per cell)'); % add labels and set font sizes
fontname(gcf,"Arial"); fontsize(gcf,8,'points'); ylim([0,75])

% do 1way anova of mean pulse duration compared to the control
[~,~,stats] = anova1(paDF.EKAR_Mean_Dur,paDF.treatment,'off');
[results,~,~,gnames] = multcompare(stats,"CriticalValueType","dunnett",'ControlGroup',find(contains(gnames,'1 vehicle')),'Display','off'); 
ERKpulseDurStats = array2table(results,"VariableNames", ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
ERKpulseDurStats.("Group") = gnames(ERKpulseDurStats.("Group"));
ERKpulseDurStats.("Control Group") = gnames(ERKpulseDurStats.("Control Group"));


%% HBE1 cells (submerged) with AMPKAR, and ERKTR reporter (and DAPI) - treated with cytokines groups
% and then vehicle/2DG/OLIGO
addpath('Z:\Code\DatalocHandler\','Z:\Code\Image Analysis\','Z:\Code\Cell Trace\')
%% Live cell Analysis
sensors = {'ERKTR_RFP','RFP_Nuc','AMPKAR','Area_YFP_Cyt'}; %,'Med_ERKTR'
fts(1).t = 'Min'; fts(1).c = 'ERKTR'; fts(1).p = 0.02;
fts(2).t = 'Max'; fts(2).c = 'ERKTR'; fts(2).p = 4; 
fts(3).t = 'minmax'; fts(3).c = 'RFP_Nuc'; fts(3).p = 400;

% Added for ampk analysis
fts(4).t = 'Min'; fts(4).c = 'AMPKAR'; fts(4).p = 0.66;
fts(5).t = 'Max'; fts(5).c = 'AMPKAR'; fts(5).p = 0.78;
fts(6).t = 'Min'; fts(6).c = 'Area_YFP_Cyt'; fts(6).p = 30;

filterp.dlength = 60; % 6 hr min for tracks
filterp.fts = fts;
dataloc2 = DatalocHandler('sensors',sensors,'filterp',filterp,'saveit',false,'load',false);

%% Pulse Analysis
pfts(1).t = 'Max'; pfts(1).c = 'dur'; pfts(1).p = 60; %I've never seen a real pulse last more than 6 hours...
dataloc2 = DatalocHandler('dataloc',dataloc2,'pulseanalysis',{'ERKTR'},'pulsefts',pfts,'saveit',false,'usepulsegui',false);
dataloc2 = DatalocHandler('dataloc',dataloc2,'pulseanalysis',{'AMPKAR'},'pulsefts',pfts,'usepulsegui',false);
[paDFa2]= convertPulseToDataframe(dataloc2,{'AMPKAR'},'aftertx',2,'tmaxaftertx',24,'pulsepars','Mean_Aftertx','tstartaftertx',6); % 
%% Rename
pat = optionalPattern(" ") + "at hour " + optionalPattern("+"|"-") + digitsPattern(1,2) + optionalPattern(" and"); % erase the "at hour +/- number
paDFa2.tx = erase(paDFa2.treatment,pat);
paDFa2.tx = strrep(paDFa2.tx,' 1 vehicle 1 vehicle', ' 1 vehicle');

paDFb2 = paDFa2(matches(paDFa2.tx,"1 NOINS 1 vehicle"|"1 fim 1 vehicle"|"1 fim 1 vehicle 10mM TwoDG"),:);
paDFb2.tx = categorical(paDFb2.tx,{'1 NOINS 1 vehicle','1 fim 1 vehicle','1 fim 1 vehicle 10mM TwoDG'},{'No Insulin','Plus Insulin','Glycolysis Inhibitor'});

%% Do statistics 
% 24 hrs
figE7Stats24 = grpstats(paDFb2,"tx",["mean","median","sem"],"DataVars","AMPKAR_Mean_Aftertx")
[~,~,stats24] = anova1(paDFb2.AMPKAR_Mean_Aftertx,paDFb2.tx,'off');

% See which are significantly different versus control (+ ins)
[resultsC24,~,~,gnamesC24] = multcompare(stats24,"CriticalValueType","dunnett",'ControlGroup',find(matches(stats24.gnames,'No Insulin')),'Display','off','Approximate',false); 
resultsTblC24 = array2table(resultsC24,"VariableNames", ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
resultsTblC24.("Group") = gnamesC24(resultsTblC24.("Group"));
resultsTblC24.("Control Group") = gnamesC24(resultsTblC24.("Control Group"))

[resultsC24,~,~,gnamesC24] = multcompare(stats24,"CriticalValueType","dunnett",'ControlGroup',find(matches(stats24.gnames,'Plus Insulin')),'Display','off','Approximate',false); 
resultsTblC24 = array2table(resultsC24,"VariableNames", ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
resultsTblC24.("Group") = gnamesC24(resultsTblC24.("Group"));
resultsTblC24.("Control Group") = gnamesC24(resultsTblC24.("Control Group"))

%% Arcos analysis
sprdChan = 'ERKTR';
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1;
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 30; %
%afts(3).t = 'Max'; afts(3).c = 'maxarea'; afts(3).p = 10000;
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2;

dataloc2 = DatalocHandler('dataloc', dataloc2, 'arcos',sprdChan,'arcosfts',afts,'arcospulse',true,'arcosminpts',4,'arcoseps',30); % was 'arcosminpts', 4



plot_by_ND('treatment', dataloc2, 'plottype', {'mean'},'channel', 'AMPKAR','tx_order', 1,'aftertreatment',1,'tmaxaftertx',24,'combinexys',true)
plot_by_ND('treatment', dataloc2, 'plottype', {'mean'},'channel', 'ERKTR','tx_order', 1,'aftertreatment',1,'tmaxaftertx',24,'combinexys',true,'ymn',0.5,'ymx',2.5)
plot_by_ND('treatment', dataloc2, 'plottype', {'sorted heatmap'},'channel', 'ERKTR','tx_order', 1,'aftertreatment',1,'tmaxaftertx',24,'combinexys',true,'ncells',100)

plot_by_ND('arcosplot',dataloc2,'analysischan',{'freq','mean dur','mean spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'tx_order',2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',false,'exclude',{'Oligo','EGF'}) % 

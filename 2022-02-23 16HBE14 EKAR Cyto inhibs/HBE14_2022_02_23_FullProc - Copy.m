%16HBE14 cells (submerged) with EKAR reporter - treated with cytokines groups and then vehicle/pd/gefetinib/toc/erki
% done - 

%% load call
% dataloc = DatalocHandler(); 
addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick')

%% Live cell data analysis and data normalization
sensors = {'EKAR','CFP_Nuc','YFP_Nuc'};
fts(1).t = 'Min'; fts(1).c = 'EKAR'; fts(1).p = 0.2;
fts(2).t = 'Max'; fts(2).c = 'EKAR'; fts(2).p = 0.7;
filterp.fts = fts;
filterp.dlength = 160; %16 hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'normalizedata','EKAR','load',false);
plotme = {'EKAR'};
plot_by_ND('treatment', dataloc, 'plottype', {'mean','sorted stacks'},'channel', plotme,'combinexys',true,'tx_order',2)
plot_by_ND('treatment', dataloc, 'plottype', {'sorted heatmaps'},'channel', plotme,'combinexys',true,'ncells',50)
% 
% plot_by_ND('treatment', dataloc, 'plottype', {'spatial heatmap'},'channel', plotme,'exclude',{'BrefeldinA','ERKi','PD'})

%% Pulse Analysis
pfts(1).t = 'Max'; pfts(1).c = 'dur'; pfts(1).p = 80;
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',{'nEKAR'}, 'saveit',false,'pulsefts',pfts);
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',{'EKAR'}, 'saveit',false,'pulsefts',pfts);

% plot_by_ND('pulseplot', dataloc, 'analysischan', {'freq','durs'},'channel',plotme,'plottype', {'percbar'}, 'aftertreatment',2)
% plot_by_ND('pulseplot', dataloc, 'analysischan', {'freq','durs'},'channel',plotme,'plottype', {'violin','box'}, 'aftertreatment',2,'overlaptx',1)
% 
% 
%% Arcos analysis
aChan = 'nEKAR';
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1;
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 60;
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2;
dataloc = DatalocHandler('dataloc',dataloc,'arcos',aChan,'arcosfts',afts,'arcospulse',true,'saveit',false,'arcosminpts',3); %,'arcoseps',40,'arcosminpts',3
dataloc = DatalocHandler('dataloc',dataloc,'arcos','EKAR','arcosfts',afts,'arcospulse',true,'saveit',false,'arcosminpts',3); %,'arcoseps',40,'arcosminpts',3

plotMe = {'nEKAR','EKAR'};
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','mean dur','mean spread size'},'channel',plotMe,'plottype',{'bar_v2'}','tx_order',2,'exclude',{'BrefeldinA','PD','EGF'},'aftertreatment', 2,'combinexys',false)
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','mean dur','mean spread size'},'channel',plotMe,'plottype',{'bar_v2'}','tx_order',2,'aftertreatment', 2,'combinexys',false)

%plot_by_ND('arcosplot',dataloc,'analysischan',{'spreadstarts'},'channel',plotMe,'plottype',{'hist3'},'overlaptx',1,'txorder',2,'aftertreatment', 2)

%% Validate Arcos
% bintest = arcos_utils.pulse2bin(dataloc.z,dataloc.d,'nEKAR');
% [clstByTime,clstByID,binz] = arcos(dataloc.d,[],'nEKAR'); %,'minpts',4, 'eps',66
% clstByID = arcos_analysis.analyze(clstByID,dataloc.d);
% clstByID = arcos_analysis.filter(clstByID,afts);
% live_movie = [dataloc.fold.im, '\',dataloc.file.im];
% MakeMoviesND(live_movie,[5:10],'moviechan', 2, 'data', dataloc.d,'spreadsbyid',clstByID,'overlaytype','detailed spreads','bindata',binz,'pmd',dataloc.platemapd.idx)



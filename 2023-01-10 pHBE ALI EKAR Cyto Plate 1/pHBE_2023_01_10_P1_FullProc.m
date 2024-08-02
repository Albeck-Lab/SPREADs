% pHBE cells (ALI) with EKAREN4 reporter
%
%% Load Call
% dataloc = DatalocHandler(); 

%% Live cell Analysis
sensors = {'EKAR','CFP_Nuc','YFP_Nuc'};
fts(1).t = 'Min'; fts(1).c = 'YFP_Nuc'; fts(1).p = 500;
fts(2).t = 'Min'; fts(2).c = 'EKAR'; fts(2).p = 0.01;
fts(3).t = 'Max'; fts(3).c = 'EKAR'; fts(3).p = 0.9;

filterp.fts = fts;
filterp.dlength = 60; %6hour min for tracks
 dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'load',false); 
% 
% plot_by_ND('treatment', dataloc, 'plottype', {'means','sorted stacks','sorted heatmap'},'channel',{'nEKAR','EKAR'},'combinexys',true)
% plot_by_ND('treatment', dataloc, 'plottype', {'means','sorted stacks','sorted heatmap'},'channel',{'nEKAR','EKAR'})

plot_by_ND('treatment', dataloc, 'plottype', {'means'},'channel',{'EKAR'})% 'spatialheatmap'


%% IF Analysis
% preLoc: Structure defining first dataset (e.g. live-cell movie)
%           .imag - File path/name of the image file(s)
%           .proc - File path/basename of the processed data
% movieLoc.imag = 'H:\2022-05-12 HBE1 EKAR Cyto HC Inhibs\2022-05-12 HBE1 EKAR Cyto HC Inhibs.nd2';
% movieLoc.proc = 'J:\ProcessedData\Nick\2022-05-12 HBE1 EKAR Cyto HC Inhibs\2022-05-12 HBE1 EKAR Cyto HC Inhibs';
% ifLoc.imag = 'J:\imageData\Nick\2022-05-12 HBE1 HC Cyto pSTAT3\2022-05-12 HBE1 HC Cyto pSTAT3.nd2';
% ifLoc.proc = 'J:\ProcessedData\Nick\2022-05-12 HBE1 HC Cyto pSTAT3\2022-05-12 HBE1 HC Cyto pSTAT3';
% iman_imappend_ND(movieLoc, ifLoc, 'wells',[2:96],'saveloc','D:\Data\2022-05-12 HBE1 EKAR Aligned\2022-05-12 HBE1 EKAR Cyto HC Inhibs','nw',5,'showalign',true)

% append = 'D:\Data\2022-05-12 HBE1 EKAR Aligned\2022-05-12 HBE1 EKAR Cyto HC Inhibs_append_xy';
% appendchans = {'Orange_Nuc'};
% dataloc = DatalocHandler('dataloc',dataloc,'append',append,'appendchans',appendchans);
% plot_by_ND('treatment', dataloc, 'plottype', {'ifplot'},'channel', {'nEKAR','EKAR'},'combinexys',true,'ifchan','Orange_Nuc')
% plot_by_ND('treatment', dataloc, 'plottype', {'ifplot'},'channel', {'nEKAR','EKAR'},'ifchan','Orange_Nuc')

%% Pulse Analysis
pulseChan = {'EKAR'};
pFts(1).t = 'max'; pFts(1).c = 'dur'; pFts(1).p = 60; % 6 hr pulse max
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pFts,'saveit',false);
% plot_by_ND('pulseplot', dataloc, 'plottype',{'bar_v2'}, 'analysischan', {'freq', 'durs'}, 'channel', pulseChan,'tmaxaftertx',4,'addstats',false)
% plot_by_ND('pulseplot', dataloc, 'plottype',{'bar_v2'}, 'analysischan', {'freq', 'durs'}, 'channel', pulseChan,'tstartaftertx',4,'tmaxaftertx',24,'addstats',false)

%% Arcos analysis
 sprdChan = {'EKAR'};
 afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1;
 afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 50;
 afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2;
 dataloc = DatalocHandler('dataloc', dataloc, 'arcos',sprdChan,'arcosfts',afts,'arcospulse',true,'arcosminpts',4); % ,'arcosminpts',4,'arcoseps',100,'arcosperc',80
 plot_by_ND('arcosplot',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'aftertreatment',2,'addstats',false,'combinexys',false)%,'spread size','dur'

% live_movie = '\\albecklab.mcb.ucdavis.edu\Data2\imageData\Nick\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array.nd2';
% MakeMoviesND(live_movie,50,'moviechan', 4, 'data', dataloc.arcos_nERKTR,'overlaytype','arcos')

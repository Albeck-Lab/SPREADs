% pHBE cells (ALI) with EKAREN4 reporter
%
addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick','\\albecklab.mcb.ucdavis.edu\data\Code\Cell Trace','\\albecklab.mcb.ucdavis.edu\data\Code\Image Analysis')

%% Load Call
%dataloc = DatalocHandler(); 

%% Live cell Analysis
sensors = {'EKAR','YFP_Nuc'};
fts(1).t = 'Min'; fts(1).c = 'YFP_Nuc'; fts(1).p = 400;
% fts(2).t = 'Min'; fts(2).c = 'EKAR'; fts(2).p = 0.1;
% fts(3).t = 'Max'; fts(3).c = 'EKAR'; fts(3).p = 0.75;

filterp.fts = fts;
filterp.dlength = 60; %6hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'normalizedata',{'EKAR'},'makenan',[1,2]); 

plot_by_ND('treatment', dataloc, 'plottype', {'means','sorted stacks','sorted heatmap'},'channel',{'nEKAR','EKAR'},'combinexys',true)
plot_by_ND('treatment', dataloc, 'plottype', {'means','sorted stacks','sorted heatmap'},'channel',{'nEKAR','EKAR'})

% plot_by_ND('treatment', dataloc, 'plottype', {'means'},'channel',{'nEKAR','EKAR'})% 'spatialheatmap'

%% Pulse Analysis
pulseChan = {'EKAR'};
pFts(1).t = 'max'; pFts(1).c = 'dur'; pFts(1).p = 60; % 6 hr pulse max
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pFts,'saveit',false); % 

pulseChan = {'nEKAR'};
pFts(1).t = 'max'; pFts(1).c = 'dur'; pFts(1).p = 60; % 6 hr pulse max
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pFts,'saveit',false); % 
%% Arcos analysis
sprdChan = {'nEKAR'};
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1; % wave should last more than 6 minutes
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 80; % wave should last less than 8 hours
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2; % wave should include more than 2 cells
dataloc = DatalocHandler('dataloc', dataloc,'arcos',sprdChan,'arcosfts',afts,'arcospulse',true,'arcosminpts',3,'saveit',false); % ),'arcoseps',30,'arcosminpts',4
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'tmaxaftertx',25,'tx_order',1,'aftertreatment',2,'combinexys',false,'exclude','EGF')

% plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','spread size','dur'},'channel',sprdChan,'plottype',{'box'},'aftertreatment',1)
% plot_by_ND('arcosplot',dataloc,'analysischan',{'spreadsorigin'},'channel',sprdChan,'plottype',{'hist3'},'aftertreatment',1)

% live_movie = '\\albecklab.mcb.ucdavis.edu\Data2\imageData\Nick\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array.nd2';
% MakeMoviesND(live_movie,50,'moviechan', 4, 'data', dataloc.arcos_nERKTR,'overlaytype','arcos')

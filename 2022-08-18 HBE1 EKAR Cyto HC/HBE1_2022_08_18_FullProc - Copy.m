%HBE1 cells (submerged) with EKAREN4 reporter - +/- HC overnight  (has all other growth factors except EGF and BNE)
% then treated with cytokines
% cells were fixed at the end of the experiment
% 3 minute intervals for images

addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick')

%% Load Call
%dataloc = DatalocHandler(); 

%% Live cell Analysis
sensors = {'EKAR','CFP_Nuc','YFP_Nuc'};
fts(1).t = 'Max'; fts(1).c = 'EKAR'; fts(1).p = 0.5;
fts(2).t = 'Min'; fts(2).c = 'YFP_Nuc'; fts(2).p = 1000;
% fts(3).t = 'Min'; fts(3).c = 'EKAR'; fts(3).p = 0.1;
% fts(4).t = 'Max'; fts(4).c = 'EKAR'; fts(4).p = 0.8;
filterp.fts = fts;
filterp.dlength = 200; %10 hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'load',false,'saveit',false,'makenan',true); 

plot_by_ND('treatment', dataloc, 'plottype', {'means','sorted stacks'},'channel',{'EKAR'})
% plot_by_ND('treatment', dataloc, 'plottype', {'spatialheatmap'},'channel',{'EKAR'},'combinexys',false,'ncells',200)


%% Pulse Analysis
pulseChan = {'EKAR'};
pFts(1).t = 'max'; pFts(1).c = 'dur'; pFts(1).p = 120; % 6 hr pulse max
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pFts,'saveit',false);

%% Arcos analysis
sprdChan = {'EKAR'};
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1; % wave should last more than 6 minutes
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 120; % wave should last less than 6 hours
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2; % wave should include more than 2 cells
dataloc = DatalocHandler('dataloc', dataloc,'arcos',sprdChan,'arcosfts',afts,'arcospulse',true,'saveit',false); % ),'arcoseps',30,'arcosminpts',4
plot_by_ND('arcosv2',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'tmaxaftertx',24,'tx_order',2,'aftertreatment',2,'combinexys',false,'exclude',{'EGF'}) % ,'mean dur','mean spread size'

% live_movie = '\\albecklab.mcb.ucdavis.edu\Data2\imageData\Nick\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array.nd2';
% MakeMoviesND(live_movie,50,'moviechan', 4, 'data', dataloc.arcos_nERKTR,'overlaytype','arcos')

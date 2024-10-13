% pHBE1 cells (submerged) with EKAREN4 reporter
% than treated with cytokines
%
% done - 
%% Load Call
%dataloc = DatalocHandler(); 

%% Live cell Analysis
sensors = {'EKAR','CFP_Nuc','YFP_Nuc'};
fts(1).t = '25prctmin'; fts(1).c = 'CFP_Nuc'; fts(1).p = 500;
fts(2).t = '25prctmin'; fts(2).c = 'YFP_Nuc'; fts(2).p = 500;
fts(3).t = 'Min'; fts(3).c = 'EKAR'; fts(3).p = 0.35;
fts(4).t = 'Max'; fts(4).c = 'EKAR'; fts(4).p = 0.8;

filterp.fts = fts;
filterp.dlength = 60; %6 hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'saveit',false,'load',false); 

plot_by_ND('treatment', dataloc, 'plottype', {'mean','sorted stacks'},'channel',{'EKAR'},'tx_order',2)
plot_by_ND('treatment', dataloc, 'plottype', {'sorted heatmap'},'channel',{'EKAR'},'ncells',200,'tx_order',2,'combinexys',false)

% plot_by_ND('treatment', dataloc, 'plottype', {'means','sorted stacks','intensity bin'},'channel',{'nEKAR','EKAR'},'combinexys',true)
% plot_by_ND('treatment', dataloc, 'plottype', {'sorted heatmap'},'channel',{'nEKAR','EKAR'},'combinexys',true)
% plot_by_ND('treatment', dataloc, 'plottype', {'spatialheatmap'},'channel',{'nEKAR','EKAR'})
% 
% plot_by_ND('treatment', dataloc, 'plottype', {'means'},'channel',{'nEKAR','EKAR'})% 'spatialheatmap'

%% Pulse Analysis
pulseChan = {'EKAR'};
pFts(1).t = 'max'; pFts(1).c = 'dur'; pFts(1).p = 60; % 6 hr pulse max
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pFts,'saveit',false); % 

%% Arcos analysis
sprdChan = {'EKAR'};
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1; % wave should last more than 6 minutes
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 80; % wave should last less than 8 hours
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2; % wave should include more than 2 cells
afts2{1} = afts; afts2{2} = afts; 
dataloc = DatalocHandler('dataloc', dataloc,'arcos',sprdChan,'arcosfts',afts2,'arcospulse',true,'arcosminpts',3,'saveit',false); % ),'arcoseps',30,'arcosminpts',4
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'tmaxaftertx',25,'tx_order',2,'aftertreatment',2,'combinexys',false,'exclude','EGF')
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'tmaxaftertx',25,'tx_order',2,'aftertreatment',2,'combinexys',false,'subset','f_im')

% live_movie = '\\albecklab.mcb.ucdavis.edu\Data2\imageData\Nick\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array.nd2';
% MakeMoviesND(live_movie,50,'moviechan', 4, 'data', dataloc.arcos_nERKTR,'overlaytype','arcos')

% HBE1 cells (submerged with EKAREN4 reporter - +/- gefitinhib)
% (has all other growth factors except EGF and BNE)
% then treated with cytokines
%
% done - 
addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick','\\albecklab.mcb.ucdavis.edu\data\Code\Cell Trace','\\albecklab.mcb.ucdavis.edu\data\Code\Image Analysis')
%% Load Call
%dataloc = DatalocHandler(); 

%% Spatial Live Cell Analysis
sensors = {'EKAR'};
fts(1).t = 'Min';  fts(1).c = 'EKAR'; fts(1).p = 0.2;
fts(2).t = 'Max';  fts(2).c = 'EKAR'; fts(2).p = 0.55;
%fts(3).t = 'twin'; fts(3).c = 'EKAR'; fts(3).p = [200,250];
filterp.fts = fts;
filterp.dlength = 200; % 20 hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'saveit',false,'load',false); 
plot_by_ND('treatment', dataloc, 'plottype', {'spatial heatmaps'},'channel',{'EKAR'},'zerohrtx',2,'tx_order',2,'combinexys',false,'exclude',{'gef'},'subset',{'il1b'})
plot_by_ND('treatment', dataloc, 'plottype', {'spatial heatmaps'},'channel',{'EKAR'},'zerohrtx',2,'tx_order',3,'combinexys',false,'exclude',{'gef'},'subset',{'il1b','veh'},'ncells',200)

%% Live cell Analysis
sensors = {'EKAR','ERKTR_RFP'};
fts(1).t = 'Min'; fts(1).c = 'EKAR'; fts(1).p = 0.2;
fts(2).t = 'Max'; fts(2).c = 'EKAR'; fts(2).p = 0.55;
%fts(3).t = 'twin'; fts(3).c = 'EKAR'; fts(3).p = [200,250];
filterp.fts = fts;
filterp.dlength = 120; % 12 hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'normalizedata',{'EKAR'},'saveit',false,'load',false); 
plot_by_ND('treatment', dataloc, 'plottype', {'mean','sorted stacks'},'channel',{'nEKAR','EKAR'})

%% Pulse Analysis
pulseChan = {'nEKAR','EKAR'};
pFts(1).t = 'max'; pFts(1).c = 'dur'; pFts(1).p = 60; % 6 hr pulse max
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pFts,'saveit',false,'usepulsegui',false);

%% Arcos analysis
sprdChan = {'nEKAR','EKAR'};
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1; % wave should last more than 6 minutes
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 60; % wave should last less than 6 hours
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2; % wave should include more than 2 cells
afts2{1} = afts; afts2{2} = afts; 
dataloc = DatalocHandler('dataloc', dataloc,'arcos',sprdChan,'arcosfts',afts2,'arcospulse',true,'saveit',false); % ),'arcoseps',30,'arcosminpts',4
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'tmaxaftertx',24,'tx_order',2,'aftertreatment',2,'combinexys',false,'exclude','EGF')

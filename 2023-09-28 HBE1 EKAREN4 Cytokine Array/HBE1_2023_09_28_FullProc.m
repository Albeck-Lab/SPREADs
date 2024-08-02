% HBE1 cells (submerged with EKAREN4 reporter - +/- INS HC and 2DG)
% (has all other growth factors except EGF and BNE)
% then treated with cytokines
%
% done - 
addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick','\\albecklab.mcb.ucdavis.edu\data\Code\Cell Trace','\\albecklab.mcb.ucdavis.edu\data\Code\Image Analysis')
%% Load Call
%dataloc = DatalocHandler(); 

%% Live cell Analysis
sensors = {'EKAR','YFP_Nuc'};
fts(1).t = 'Min'; fts(1).c = 'EKAR'; fts(1).p = 0.2;
fts(2).t = 'Max'; fts(2).c = 'EKAR'; fts(2).p = 0.6;
fts(3).t = 'Min'; fts(3).c = 'YFP_Nuc'; fts(3).p = 1500;
filterp.fts = fts;
filterp.dlength = 120; % 12 hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'saveit',false,'load',false); 
% 
% plot_by_ND('treatment', dataloc, 'plottype', {'mean','sorted stacks'},'channel',{'EKAR'})
% plot_by_ND('treatment', dataloc, 'plottype', {'sorted heatmap'},'channel',{'EKAR'},'ncells',100,'tx_order',2)

%% Pulse Analysis
pulseChan = {'EKAR'};
pFts(1).t = 'max'; pFts(1).c = 'dur'; pFts(1).p = 60; % 6 hr pulse max
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pFts,'usepulsegui',false); % 

%% Arcos analysis
sprdChan = {'EKAR'};
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1; % wave should last more than 6 minutes
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 30; % wave should last less than 3 hours
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2; % wave should include more than 2 cells
dataloc = DatalocHandler('dataloc', dataloc,'arcos',sprdChan,'arcosfts',afts,'arcospulse',true,'arcosminpts',3); % 'arcoseps',30,'arcosminpts',4

% plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','durs','mean durs','spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'tx_order',2,'aftertreatment',1,'combinexys',false,'exclude','EGF','tmaxaftertx',24)
% plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','durs','mean durs','spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'tx_order',2,'aftertreatment',1,'combinexys',false,'tmaxaftertx',24)
% 
% plot_by_ND('arcosplot',dataloc,'analysischan',{'mean spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'tx_order',2,'aftertreatment',1,'combinexys',false,'exclude','EGF','tmaxaftertx',24)
% 
% plot_by_ND('arcosplot',dataloc,'analysischan',{'durs','spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'tx_order',2,'aftertreatment',1,'combinexys',false,'tmaxaftertx',24,'showrawdata',false)
% plot_by_ND('arcosplot',dataloc,'analysischan',{'durs','spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'tx_order',2,'aftertreatment',1,'combinexys',false,'tmaxaftertx',24,'exclude','EGF','showrawdata',false)

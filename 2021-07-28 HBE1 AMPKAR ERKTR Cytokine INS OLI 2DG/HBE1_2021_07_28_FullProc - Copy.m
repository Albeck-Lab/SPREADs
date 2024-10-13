%% HBE1 cells (submerged) with AMPKAR, and ERKTR reporter (and DAPI) - treated with cytokines groups
% and then vehicle/2DG/OLIGO
addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick')
%% Live cell Analysis
sensors = {'ERKTR_RFP','RFP_Nuc'}; %,'Med_ERKTR'
fts(1).t = 'Min'; fts(1).c = 'ERKTR'; fts(1).p = 0.02;
fts(2).t = 'Max'; fts(2).c = 'ERKTR'; fts(2).p = 4; 
fts(3).t = 'minmax'; fts(3).c = 'RFP_Nuc'; fts(3).p = 400;
filterp.dlength = 60; % 6 hr min for tracks
filterp.fts = fts;
dataloc2 = DatalocHandler('sensors',sensors,'filterp',filterp,'saveit',false,'load',false);
plot_by_ND('treatment', dataloc2, 'plottype', {'mean'},'channel', 'ERKTR','tx_order', 1,'aftertreatment',1,'tmaxaftertx',24,'combinexys',true,'ymn',0.5,'ymx',2.5)
plot_by_ND('treatment', dataloc2, 'plottype', {'sorted heatmap'},'channel', 'ERKTR','tx_order', 1,'aftertreatment',1,'tmaxaftertx',24,'combinexys',true,'ncells',100)

%% Pulse Analysis
pfts(1).t = 'Max'; pfts(1).c = 'dur'; pfts(1).p = 60; %I've never seen a real pulse last more than 6 hours...
dataloc2 = DatalocHandler('dataloc',dataloc2,'pulseanalysis',{'ERKTR'},'pulsefts',pfts,'saveit',false);

%% Arcos analysis
sprdChan = 'ERKTR';
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1;
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 30; %
%afts(3).t = 'Max'; afts(3).c = 'maxarea'; afts(3).p = 10000;
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2;

dataloc2 = DatalocHandler('dataloc', dataloc2, 'arcos',sprdChan,'arcosfts',afts,'arcospulse',true,'arcosminpts',4,'arcoseps',30); % was 'arcosminpts', 4
plot_by_ND('arcosplot',dataloc2,'analysischan',{'freq','mean dur','mean spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'tx_order',2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',false,'exclude',{'Oligo','EGF'}) % 

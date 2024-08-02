% pHBE cells (ALI) with EKAREN4 reporter
%
%% Load Call
% dataloc = DatalocHandler(); 

%% Live cell Analysis
sensors = {'EKAR','CFP_Nuc','YFP_Nuc'};
fts(1).t = 'Min'; fts(1).c = 'YFP_Nuc'; fts(1).p = 1200;
fts(2).t = 'Min'; fts(2).c = 'EKAR'; fts(2).p = 0.1;
fts(3).t = 'Max'; fts(3).c = 'EKAR'; fts(3).p = 0.75;

filterp.fts = fts;
filterp.dlength = 60; %6hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'normalizedata',{'EKAR'},'load',false,'saveit',false); 
% 
 %plot_by_ND('treatment', dataloc, 'plottype', {'means','sorted stacks','sorted heatmap'},'channel',{'nEKAR','EKAR'},'combinexys',true)
% plot_by_ND('treatment', dataloc, 'plottype', {'means','sorted stacks','sorted heatmap'},'channel',{'nEKAR','EKAR'})

 % plot_by_ND('treatment', dataloc, 'plottype', {'spatial heatmap'},'channel',{'nEKAR'})% 



%% Pulse Analysis
pulseChan = {'nEKAR','EKAR'};
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'saveit',false);
% plot_by_ND('pulseplot', dataloc, 'plottype',{'bar_v2'}, 'analysischan', {'freq', 'durs'}, 'channel', pulseChan,'tmaxaftertx',4,'addstats',false)
% plot_by_ND('pulseplot', dataloc, 'plottype',{'bar_v2'}, 'analysischan', {'freq', 'durs'}, 'channel', pulseChan,'tstartaftertx',4,'tmaxaftertx',24,'addstats',false)

%% Arcos analysis

sprdChan = {'nEKAR','EKAR'};
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1;
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 30; % 15
afts(3).t = 'Max'; afts(3).c = 'maxarea'; afts(3).p = 10000; % 5000
afts2{1} = afts; afts2{2} = afts; 
dataloc = DatalocHandler('dataloc', dataloc, 'arcos',sprdChan,'arcosfts',afts2,'arcospulse',true,'saveit', false,'arcosminpts',3);% arcospulse, false
 plot_by_ND('arcosplot',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'aftertreatment',1,'addstats',false,'combinexys',false)
%  plot_by_ND('arcosplot',dataloc,'analysischan',{'dur','spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'aftertreatment',1,'overlaptx',1,'addstats',false)

 %plot_by_ND('arcosplot',dataloc,'analysischan',{'spreadsorigin'},'channel',sprdChan,'plottype',{'hist3'},'aftertreatment',1)

% live_movie = '\\albecklab.mcb.ucdavis.edu\Data2\imageData\Nick\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array.nd2';
% MakeMoviesND(live_movie,50,'moviechan', 4, 'data', dataloc.arcos_nERKTR,'overlaytype','arcos')

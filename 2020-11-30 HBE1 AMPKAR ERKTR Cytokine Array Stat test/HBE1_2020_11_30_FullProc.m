% hbe1 cells in submerged culture, on a spot
% erktr and AMPKAR with one treatment of cytokines. 
% Groups of cytokines
% hbe1 submerged with erktr and AMPKAR with cytokines with stat3 stains and 2dg or oligo 2nd treatment

%% load call
dataloc = DatalocHandler();
plot_by_ND('treatment', dataloc, 'plottype', {'mean'},'channel', 'ERKTR','tx_order', 2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',true,'ymn',0.5,'ymx',2.5)
plot_by_ND('treatment', dataloc, 'plottype', {'sorted heatmap'},'channel', 'ERKTR','tx_order', 2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',true,'ncells',100,'ymn',0.5,'ymx',2.5)


%% Live cell analysis
sensors = {'ERKTR_RFP', 'RFP_Nuc'};
fts(1).t = 'Min'; fts(1).c = 'ERKTR'; fts(1).p = 0;
fts(2).t = 'Max'; fts(2).c = 'ERKTR'; fts(2).p = 3;
fts(3).t = 'minmax';  fts(3).c = 'RFP_Nuc';  fts(3).p = 1500;
filterp.dlength = 120; % 12 hour min
filterp.fts = fts;

dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'saveit',false,'load',false);
plot_by_ND('treatment', dataloc, 'plottype', {'mean'},'channel', 'ERKTR','tx_order', 2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',true,'ymn',0.5,'ymx',2.5)
plot_by_ND('treatment', dataloc, 'plottype', {'sorted heatmap'},'channel', 'ERKTR','tx_order', 2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',true,'ncells',100)

%% Pulse Analysis
pfts(1).t = 'Max'; pfts(1).c = 'dur'; pfts(1).p = 60; %I've never seen a real pulse last more than 6 hours...
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',{'ERKTR'},'pulsefts',pfts,'saveit',false);

%% Arcos analysis
sprdChan = 'ERKTR';
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1;
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 30;
%afts(3).t = 'Max'; afts(3).c = 'maxarea'; afts(3).p = 10000;
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2;

dataloc = DatalocHandler('dataloc', dataloc, 'arcos',sprdChan,'arcosfts',afts,'arcospulse',true); %,
plot_by_ND('arcosplot',dataloc,'analysischan',{'mean spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'overlaptx',2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',false,'exclude',{'EGF','IL620','TNFa20','Sim'})
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','mean dur','spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'overlaptx',2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',false,'exclude',{'EGF','IL620','TNFa20','Sim'})
plot_by_ND('arcosplot',dataloc,'analysischan',{'spread size'},'channel',sprdChan,'plottype',{'bar_v2'},'overlaptx',2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',false,'exclude',{'IL620','TNFa20','Sim'},'showrawdata',false)

% hbe1 submerged with erktr and AMPKAR with cytokines with stat3 stains and 2dg or oligo 2nd treatment
addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick','\\albecklab.mcb.ucdavis.edu\data\Code\Image Analysis\','\\albecklab.mcb.ucdavis.edu\data\Code\Cell Trace\')

%% load call
%dataloc = DatalocHandler();

%% Live cell Analysis
sensors = {'ERKTR_RFP','RFP_Nuc','AMPKAR','Area_YFP_Cyt'}; %,'Med_ERKTR'
fts(1).t = 'Min'; fts(1).c = 'ERKTR'; fts(1).p = 0.02;
fts(2).t = 'Max'; fts(2).c = 'ERKTR'; fts(2).p = 4; 
fts(3).t = 'minmax'; fts(3).c = 'RFP_Nuc'; fts(3).p = 400;

% Added for ampk analysis
fts(4).t = 'Min'; fts(4).c = 'AMPKAR'; fts(4).p = 0.3;
fts(5).t = 'Max'; fts(5).c = 'AMPKAR'; fts(5).p = 0.7;
fts(6).t = 'Min'; fts(6).c = 'Area_YFP_Cyt'; fts(6).p = 40;

filterp.dlength = 60; % 6 hr min for tracks
filterp.fts = fts;
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'saveit',false,'load',false);
plot_by_ND('treatment', dataloc, 'plottype', {'mean'},'channel', 'AMPKAR','tx_order', 1,'aftertreatment',2,'tmaxaftertx',24,'combinexys',true,'ymn',0.38,'ymx',0.55)
plot_by_ND('treatment', dataloc, 'plottype', {'sorted stacks'},'channel', 'AMPKAR','tx_order', 1,'aftertreatment',2,'tmaxaftertx',24,'combinexys',true,'ymn',0.35,'ymx',0.55)

plot_by_ND('treatment', dataloc, 'plottype', {'mean'},'channel', 'ERKTR','tx_order', 1,'aftertreatment',1,'tmaxaftertx',24,'combinexys',true,'ymn',0.5,'ymx',2.5)
plot_by_ND('treatment', dataloc, 'plottype', {'sorted heatmap'},'channel', 'ERKTR','tx_order', 1,'aftertreatment',1,'tmaxaftertx',24,'combinexys',true,'ncells',100)

%% Pulse Analysis
pfts(1).t = 'Max'; pfts(1).c = 'dur'; pfts(1).p = 60; %I've never seen a real pulse last more than 6 hours...
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',{'ERKTR'},'pulsefts',pfts,'saveit',false);

%% Arcos analysis
sprdChan = 'ERKTR';
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1;
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 30; %
%afts(3).t = 'Max'; afts(3).c = 'maxarea'; afts(3).p = 10000;
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2;

dataloc = DatalocHandler('dataloc', dataloc, 'arcos',sprdChan,'arcosfts',afts,'arcospulse',true,'arcosminpts',4); % was 'arcosminpts', 3, 'arcoseps', 40
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'tx_order',2,'aftertreatment',2,'tmaxaftertx',24,'combinexys',false,'exclude',{'Oligo','EGF'},'control',20) % 


%% IF Analysis
% % preLoc: Structure defining first dataset (e.g. live-cell movie)
% %           .imag - File path/name of the image file(s)
% %           .proc - File path/basename of the processed data
% movieLoc.imag = 'J:\imageData\Nick\2021-08-18 HBE1 AE Cyto INS 2DG OLI\2021-08-18 HBE1 AE Cyto INS 2DG OLI.nd2';
% movieLoc.proc = 'J:\ProcessedData\Nick\2021-08-18 HBE1 AE Cyto INS 2DG OLI\2021-08-18 HBE1 AE Cyto INS 2DG OLI';
% ifLoc.imag = 'J:\imageData\Devan\Fixed\HBE1 paper\2021-08-18 AE Cyto Ins\2021-08-18 HBE AE Cyto INS 2DG OLI pSTAT3.nd2';
% ifLoc.proc = 'J:\ProcessedData\Devan\HBE1 paper\2021-08-18 HBE AE Cytokines\HBE1_AEcytokine20210818F_pSTAT3';
% iman_imappend_ND(movieLoc, ifLoc, 'wells',[1:75,77],'saveloc','D:\Data\2021-08-18 HBE1 AE Cyto Aligned\2021-08-18 HBE1 AE Cyto INS 2DG OLI','nw',5,'showalign',true)
% 
% append = 'D:\Data\2021-08-18 HBE1 AE Cyto Aligned\2021-08-18 HBE1 AE Cyto INS 2DG OLI_append_xy';
% appendchans = {'CY5_Nuc'};
% dataloc = DatalocHandler('dataloc',dataloc,'append',append,'appendchans',appendchans);
% plot_by_ND('treatment', dataloc, 'plottype', {'slope vs if'},'channel', {'nERKTR'},'combinexys',true,'ifchan',appendchans{1})
% plot_by_ND('treatment', dataloc, 'plottype', {'slope vs if'},'channel', {'nERKTR'},'ifchan',appendchans{1})
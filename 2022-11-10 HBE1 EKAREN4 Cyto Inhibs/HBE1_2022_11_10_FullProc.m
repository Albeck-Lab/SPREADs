% HBE1 cells (submerged with EKAREN4 reporter - +/- gefitinhib or tocilizumab
% (has all other growth factors except EGF and BNE)
% then treated with cytokines
% cells were fixed at the end of the experiment and i did pSTAT3 stain on
% them
%
% done - 
addpath('Z:\Code\Nick','Z:\Code\Cell Trace','Z:\Code\Image Analysis')
%% Load Call
%dataloc = DatalocHandler(); 

%% Live cell Analysis
sensors = {'EKAR'};
%fts(1).t = 'Min'; fts(1).c = 'EKAR'; fts(1).p = 0.2;
fts(1).t = 'Max'; fts(1).c = 'EKAR'; fts(1).p = 0.7;
%fts(3).t = 'twin'; fts(3).c = 'EKAR'; fts(3).p = [200,250];

filterp.fts = fts;
filterp.dlength = 80; % 8 hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'saveit',false,'load',false,'makenan',true); 
% plot_by_ND('treatment', dataloc, 'plottype', {'means'},'channel',{'EKAR'},'tx_order',2,'tmaxaftertx',3,'aftertreatment',2)% 
% plot_by_ND('treatment', dataloc, 'plottype', {'means'},'channel',{'EKAR'},'tx_order',3) % 

%% IF Analysis
% preLoc: Structure defining first dataset (e.g. live-cell movie)
%           .imag - File path/name of the image file(s)
%           .proc - File path/basename of the processed data
% movieLoc.imag = '\\albecklab.mcb.ucdavis.edu\data\imageData\Nick\2022-11-10 HBE1 EKAREN4 Cyto Inhibs\2022-11-10 HBE1 EKAREN4 Cyto Inhibs.nd2';
% movieLoc.proc = '\\albecklab.mcb.ucdavis.edu\data\Processed Data\Nick\2022-11-10 HBE1 EKAREN4 Cyto Inhibs\2022-11-10 HBE1 EKAREN4 Cyto Inhibs';
% ifLoc.imag = '\\albecklab.mcb.ucdavis.edu\data\imageData\Nick\2022-11-10 HBE1 EKAREN4 Cyto Inhibs pSTAT3\2022-11-10 HBE1 EKAREN4 Cyto Inhibs pSTAT3 run2.nd2';
% ifLoc.proc = '\\albecklab.mcb.ucdavis.edu\data\Processed Data\Nick\2022-11-10 HBE1 EKAREN4 Cyto Inhibs pSTAT3\2022-11-10 HBE1 EKAREN4 Cyto Inhibs pSTAT3';
% saveloc = '\\albecklab.mcb.ucdavis.edu\data\Processed Data\Nick\AlignedFiles\2022-11-10 HBE1 EKAREN4 Cyto Inhibs Aligned\2022-11-10 HBE1 EKAREN4 Cyto Inhibs';
% iman_imappend_ND(movieLoc, ifLoc, 'wells',[1:84],'saveloc',saveloc,'nw',5,'showalign',false)

% append = [saveloc,'_append_xy'];
% appendchans = {'CY5_Nuc'};
% dataloc = DatalocHandler('dataloc',dataloc,'append',append,'appendchans',appendchans,'saveit',false);
% dataloc = DataHandler.fixDrift(dataloc,'nEKAR');
% iman_spatialheatmap_ab_v4_ND(dataloc,19,'nEKAR',appendchans{1},'tstart',100, 'std', false,'log_if',true)

% hi = 1;
 %  plot_by_ND('treatment', dataloc, 'plottype', {'mean vs if','slope vs if'},'channel', {'nEKAR','EKAR'},'combinexys',true,'ifchan','CY5_Nuc','tx_order',2)
%  plot_by_ND('treatment', dataloc, 'plottype', {'mean vs if','slope vs if'},'channel', {'nEKAR','EKAR'},'ifchan','CY5_Nuc','tx_order',2)
% 
%% Pulse Analysis
pulseChan = {'EKAR'};
pfts(1).t = 'Max'; pfts(1).c = 'dur'; pfts(1).p = 30;
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pfts,'saveit',false,'usepulsegui',false);

 %% Arcos analysis
sprdChan = {'EKAR'};
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1; % 6 m
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 30; % 3 hour spread max
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2;
dataloc = DatalocHandler('dataloc', dataloc,'arcos',sprdChan,'arcosfts',afts,'arcospulse',true,'arcosparfor',true); % had 'arcosminpts', 3 ,'arcosparfor',true
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'aftertreatment',2,'tx_order',3,'combinexys',false,'exclude',{'EGF'},'tmaxaftertx',24,'control',18)
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq'},'channel',sprdChan,'plottype',{'bar_v2'},'aftertreatment',2,'tx_order',3,'combinexys',false,'exclude',{'EGF'},'control',18)

%% Get the SPREAD data from it!
data1 = convertSPREADToDataframe2(dataloc, 'EKAR', 'aftertx',2,'exclude',{'EGF'},'tmaxaftertx',24);

% pull the single cytokine data
no10 = ~contains(data1.txinfo,'10ng/mL'); % only need the 20ng/mL data
data2 = data1(no10,:);

% now give the treatments prettier names
oldTxNames = {'1 fim 1 vehicle 1 vehicle', '1 fim 10ug/mL Tocilizumab 1 vehicle', '1 fim 1uM Gefitinib 1 vehicle',...
              '1 fim 1 vehicle 20ng/mL IL6', '1 fim 10ug/mL Tocilizumab 20ng/mL IL6', '1 fim 1uM Gefitinib 20ng/mL IL6',...
              '1 fim 1 vehicle 20ng/mL IL1b', '1 fim 10ug/mL Tocilizumab 20ng/mL IL1b', '1 fim 1uM Gefitinib 20ng/mL IL1b',...
              '1 fim 1 vehicle 20ng/mL IFNy', '1 fim 10ug/mL Tocilizumab 20ng/mL IFNy', '1 fim 1uM Gefitinib 20ng/mL IFNy',...
              };
txNames = {'Veh + Veh','Toc + Veh','Gef + Veh',...
           'IL6 + Veh','IL6 + Toc','IL6 + Gef',...
           'IL1b + Veh','IL1b + Toc','IL1b + Gef',...
           'IFNy + Veh','IFNy + Toc','IFNy + Gef',...
           };
data2.exptx = categorical(data2.txinfo,oldTxNames,txNames);

% get the statistics for plotting
freqData = grpstats(data2,"exptx",["mean","median","sem"],"DataVars","freq")

sprdBar = bar(freqData.exptx,freqData.mean_freq, 'FaceColor','flat', 'EdgeColor','k', 'LineWidth',1); % plot the mean
ylim([0,9])

%% Example movie maker where live-cell movies are plotted with Arcos analysis on top of it

% live_movie = '\\albecklab.mcb.ucdavis.edu\Data2\imageData\Nick\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array.nd2';
% MakeMoviesND(live_movie,50,'moviechan', 4, 'data', dataloc.arcos_nERKTR,'overlaytype','arcos')

%plot_by_ND('pulseplot', dataloc, 'plottype',{'roughhist','percbar'}, 'analysischan', {'freq v2'},'channel', pulseChan,'tmaxaftertx',2,'aftertreatment',3,'overlaptx',2,'tx_order',2)
% plot_by_ND('pulseplot', dataloc, 'plottype',{'roughhist','percbar'}, 'analysischan',{'freq v2'},'channel', pulseChan,'tmaxaftertx',6,'aftertreatment',3,'overlaptx',2,'tx_order',2)
% plot_by_ND('pulseplot', dataloc, 'plottype',{'box','roughhist','percbar'}, 'analysischan',{'freq v2'},'channel', pulseChan,'tstartaftertx',6,'aftertreatment',3,'overlaptx',2,'tx_order',2)
% plot_by_ND('pulseplot', dataloc, 'plottype',{'violin','box','percbar'}, 'analysischan', {'mean', 'durs'},'channel', pulseChan,'tmaxaftertx',2,'aftertreatment',1,'overlaptx',2,'tx_order',2)
% plot_by_ND('pulseplot', dataloc, 'plottype',{'violin','box','percbar'}, 'analysischan',{'mean', 'durs'},'channel', pulseChan,'tmaxaftertx',6,'aftertreatment',1,'overlaptx',2,'tx_order',2)
% plot_by_ND('pulseplot', dataloc, 'plottype',{'violin','box','percbar'}, 'analysischan',{'mean', 'durs'},'channel', pulseChan,'tstartaftertx',6,'aftertreatment',1,'overlaptx',2,'tx_order',2)
%plot_by_ND('treatment', dataloc, 'plottype', {'spatial heatmaps'},'channel',{'nEKAR','EKAR'})

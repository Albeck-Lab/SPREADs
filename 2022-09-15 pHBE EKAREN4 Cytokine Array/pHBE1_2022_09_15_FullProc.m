% pHBE cells (submerged) with EKAREN4 reporter - CompleteA media w/o
% growth factors, treated with cytokines
%
% done - 


%% Load Call
% dataloc = DatalocHandler(); 

% For Analysis
% pars =  {'Mean','Mean^2','Frequency','Mean_Dur','Mean_Deriv','Peak_Amp','Mean_Amp','DurFirstP','Peak_Max','Peak_Mean','LiveCell'};
% [paDF,txTbl]= convertPulseToDataframe(dataloc,{'nEKAR'},'aftertx',2,'tstartaftertx',2,'tmaxaftertx',22,'pulsepars',pars);
% writetable(paDF,'C:\Users\ndecuzzi\Desktop\primaryCellERK_data.csv') 
% subz = contains(paDF.treatment,"20ng/mL IL1b");
% stats = grpstats(paDF(subz,:),"treatment",["mean","std","sem"],DataVars="nEKAR_Mean");
% p = kruskalwallis(paDF.nEKAR_Mean,paDF.treatment);
% [p,t,stats] = anova1(paDF.nEKAR_Mean,paDF.treatment);
% [~,~,stats] = anova1(paDF.nEKAR_Mean(subz),paDF.treatment(subz));
% [results,~,~,gnames] = multcompare(stats,"CriticalValueType","dunnett",'ControlGroup',1,'Display','off'); %

%% Live cell Analysis
sensors = {'EKAR','YFP_Nuc'};
fts(1).t = 'Min'; fts(1).c = 'YFP_Nuc'; fts(1).p = 700;
fts(2).t = 'Min'; fts(2).c = 'EKAR'; fts(2).p = 0.2;
fts(3).t = 'Max'; fts(3).c = 'EKAR'; fts(3).p = 0.9;
filterp.fts = fts;
filterp.dlength = 120; %12 hour min for tracks
dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'normalizedata',{'EKAR'},'load',false,'saveit',false); 
plot_by_ND('treatment',dataloc,'channel','EKAR','tmaxaftertx',24,'exclude','Pit','plottype','mean')%,'ymn',0.35,'ymx',0.6
plot_by_ND('treatment',dataloc,'channel','EKAR','tmaxaftertx',24,'exclude','Pit','plottype','spatialheatmap','ncells',200,'combinexys',false)
plot_by_ND('treatment',dataloc,'channel','nEKAR','tmaxaftertx',24,'exclude','Pit','plottype','spatialheatmap','ncells',200,'combinexys',false)

%% Pulse Analysis
pulseChan = {'EKAR'};
pFts(1).t = 'max'; pFts(1).c = 'dur'; pFts(1).p = 90; % 9 hr pulse max
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pFts,'saveit',false);

plot_by_ND('pulseplot', dataloc, 'plottype',{'bar_v2'}, 'analysischan', {'freq', 'durs','mean'}, 'channel', {'EKAR'},'tx_order',2,'aftertreatment',2,'showrawdata',false,'tmaxaftertx',24)
%  plot_by_ND('pulseplot', dataloc, 'plottype',{'bar_v2'}, 'analysischan', {'freq', 'durs'}, 'channel', pulseChan,'tmaxaftertx',6,'tx_order',2,'aftertreatment',2)
% plot_by_ND('pulseplot', dataloc, 'plottype',{'bar_v2'}, 'analysischan', {'freq', 'durs'}, 'channel', pulseChan,'tstartaftertx',6,'tmaxaftertx',24,'tx_order',2,'aftertreatment',2)

%% Arcos analysis
sprdChan = {'EKAR'};
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1; % waves should last more than 6 min
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 80; % waves should last less than 8 hours
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2; % waves should have more than 2 cells
dataloc = DatalocHandler('dataloc', dataloc, 'arcos',sprdChan,'arcosfts',afts,'arcospulse',true); %,'arcoseps',200,'arcosminpts',4
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','dur','size'},'channel',sprdChan,'plottype',{'bar_v2'},'aftertreatment',2,'combinexys',false)
% plot_by_ND('arcosplot',dataloc,'analysischan',{'spreadsorigin'},'channel',sprdChan,'plottype',{'hist3'})

% live_movie = '\\albecklab.mcb.ucdavis.edu\Data2\imageData\Nick\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array\2021-02-16 HBE1 AMPKAR ERKTR Single Cytokine Array.nd2';
% MakeMoviesND(live_movie,50,'moviechan', 4, 'data', dataloc.arcos_nERKTR,'overlaytype','arcos')

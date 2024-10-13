%HBE1 cells (submerged) with EKAR reporter - treated with cytokines groups and then vehicle/pd/gefetinib/toc/erki
% done - 01/12/2022
%% Load Call
%dataloc = DatalocHandler();


%% Live cell data
% sensors = {'EKAR','ERKTR','YFP_Nuc','RFP_Nuc'};
% fts(1).t = 'Min'; fts(1).c = 'EKAR'; fts(1).p = 0.01;
% fts(2).t = 'Max'; fts(2).c = 'EKAR'; fts(2).p = 1;
% fts(3).t = '25prctmin'; fts(3).c = 'YFP_Nuc'; fts(3).p = 300;
% fts(4).t = '25prctmin'; fts(4).c = 'RFP_Nuc'; fts(4).p = 300;
% fts(5).t = 'Min'; fts(5).c = 'ERKTR'; fts(5).p = 0.01;
% fts(6).t = 'Max'; fts(6).c = 'ERKTR'; fts(6).p = 4;
% 
% filterp.fts = fts;
% filterp.dlength = 45; %6 hour min for tracks
% % 
% DatalocHandler('sensors',sensors,'filterp',filterp,'normalizedata',{'ERKTR','EKAR'});
% plotme = {'nEKAR', 'nERKTR'};
% plot_by_ND('treatment', dataloc, 'trackplot', {'mean','spatialheatmap','spatialstacks'},'channel', plotme,'combinexys',false,'looptime',8)
% plot_by_ND('treatment', dataloc, 'trackplot', {'heatmap','stacks'}, 'channel', plotme,'looptime',8)
% plot_by_ND('treatment', dataloc,'trackplot','spatialheatmap', 'channel', plotme,'looptime',8)

%% Pulse Analysis
%dataloc = DatalocHandler('pulseanalysis',{'nERKTR','nEKAR'},'focus','mtns','fixfields',true);
% plot_by_ND('pulseplot', dataloc,'pulseplot',{'meandurspercell','frequency','peakdurs'},'channel',plotme,'aftertreatment', 2,'looptime',8)
% plot_by_ND('pulseplot', dataloc,'pulseplot',{'meandurspercell','frequency','peakdurs'},'channel',plotme,'aftertreatment', 2, 'pptype', 'boxplot','looptime',8)
% plot_by_ND('pulseplot', dataloc, 'pulseplot', {'freq','durs','mean'},'channel',plotme,'pptype', {'percbar','violin','box'},'tstartaftertx',6,'tmaxaftertx',20,'looptime',8)
% plot_by_ND('pulseplot', dataloc, 'pulseplot', {'freq','durs','mean'},'channel',plotme,'pptype', {'violin','box','percbar'},'tmaxaftertx',6,'looptime',8)
% plot_by_ND('pulseplot', dataloc, 'pulseplot', {'freq','durs','mean'},'channel',plotme,'pptype', {'violin','box','percbar'},'tstartaftertx',6,'tmaxaftertx',20,'withoutzeros',true,'looptime',8)
% plot_by_ND('pulseplot', dataloc, 'pulseplot', {'mean','freq','durs'},'channel',plotme,'pptype', {'violin','box','percbar'},'tmaxaftertx',6,'withoutzeros',true,'looptime',8)
% plot_by_ND('pulseplot', dataloc, 'pulseplot', {'freq'},'channel',plotme,'pptype', {'roughhist'},'tstartaftertx',6,'tmaxaftertx',20,'looptime',8)
% plot_by_ND('pulseplot', dataloc, 'pulseplot', {'freq'},'channel',plotme,'pptype', {'roughhist'},'tmaxaftertx',6,'looptime',8)
% plot_by_ND('pulseplot', dataloc, 'pulseplot', {'freq'},'channel',plotme,'pptype', {'roughhist'},'tstartaftertx',6,'tmaxaftertx',20,'withoutzeros',true,'looptime',8)
% plot_by_ND('pulseplot', dataloc, 'pulseplot', {'freq'},'channel',plotme,'pptype', {'roughhist'},'tmaxaftertx',6,'withoutzeros',true,'looptime',8)
% plot_by_ND('pulseplot', dataloc, 'pulseplot', {'time2pulse'},'channel',plotme,'pptype', {'percbar'},'looptime',8,'withoutzeros',true)

%% Arcos analysis
sprdChan = 'nERKTR';
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1;
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 15;
dataloc = DatalocHandler('arcos',sprdChan,'arcosfts',afts,'arcospulse',true); 
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','durs'},'channel',sprdChan,'plottype',{'violin','box'},'tx_order', 2, 'overlaptx', 1,'looptime',8)


%% ERKTR and EKAR cross corr
% dataloc = DatalocHandler('crosscorr',{'nEKAR','nERKTR'}); 

%% Plots of overlapping IF and Live Data
% num2c= 3;
% scatter(dataloc.d{num2c}.data.XCoord(:,264),dataloc.d{num2c}.data.YCoord(:,264),'o')
% lvcellid = num2str(dataloc.d{num2c}.cellindex);
% hold on
% text(dataloc.d{num2c}.data.XCoord(:,264),dataloc.d{num2c}.data.YCoord(:,264),lvcellid,'Color','blue')
% scatter(dataloc.IFd{num2c}.data.XCoord,dataloc.IFd{num2c}.data.YCoord,'+')
% ifcellid = num2str(dataloc.IFd{num2c}.cellindex);
% text(dataloc.IFd{num2c}.data.XCoord,dataloc.IFd{num2c}.data.YCoord,ifcellid,'Color','red')
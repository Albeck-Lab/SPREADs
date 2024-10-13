% HBE1 cells (submerged with EKAREN4 reporter - +/- INS HC and 2DG)
% (has all other growth factors except EGF and BNE)
% then treated with cytokines
%
% done - 
addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick','\\albecklab.mcb.ucdavis.edu\data\Code\Cell Trace','\\albecklab.mcb.ucdavis.edu\data\Code\Image Analysis')
%% Load Call
dataloc = DatalocHandler(); 

%% Live cell Analysis
sensors = {'EKAR'};
fts(1).t = 'Min'; fts(1).c = 'EKAR'; fts(1).p = 0.2;
fts(2).t = 'Max'; fts(2).c = 'EKAR'; fts(2).p = 0.6;
%fts(3).t = 'twin'; fts(3).c = 'EKAR'; fts(3).p = [200,250];
filterp.fts = fts;
filterp.dlength = 120; % 12 hour min for tracks
%dataloc = DatalocHandler('sensors',sensors,'filterp',filterp,'saveit',false,'load',false); 

plot_by_ND('treatment', dataloc, 'plottype', {'mean'},'channel',{'EKAR'},'tx_order',2,'tmaxaftertx',24)
%plot_by_ND('treatment', dataloc, 'plottype', {'heatmap'},'channel',{'EKAR'},'tx_order',2,'combinexys',false)
plot_by_ND('treatment', dataloc, 'plottype', {'sorted heatmap'},'channel',{'EKAR'},'ncells',100,'tx_order',2,'tmaxaftertx',24)
%%

%% Pulse Analysis
pulseChan = {'EKAR'};
pFts(1).t = 'max'; pFts(1).c = 'dur'; pFts(1).p = 60; % 6 hr pulse max
dataloc = DatalocHandler('dataloc',dataloc,'pulseanalysis',pulseChan,'pulsefts',pFts,'saveit',false); % 

%% Arcos analysis
sprdChan = {'EKAR'};
afts(1).t = 'Min'; afts(1).c = 'dur'; afts(1).p = 1; % wave should last more than 6 minutes
afts(2).t = 'Max'; afts(2).c = 'dur'; afts(2).p = 60; % wave should last less than 6 hours
afts(3).t = 'Min'; afts(3).c = 'maxcount'; afts(3).p = 2; % wave should include more than 2 cells
dataloc = DatalocHandler('dataloc', dataloc,'arcos',sprdChan,'arcosfts',afts,'arcospulse',true,'arcosminpts',3); % ),'arcoseps',30
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','mean durs'},'channel',sprdChan,'plottype',{'bar_v2'},'tmaxaftertx',24,'tx_order',2,'aftertreatment',2,'combinexys',false,'exclude','EGF')
plot_by_ND('arcosplot',dataloc,'analysischan',{'freq','mean durs'},'channel',sprdChan,'plottype',{'bar_v2'},'tmaxaftertx',24,'tx_order',2,'aftertreatment',2,'combinexys',false,'subset','f_im')

% 
% figure
% tiledlayout('flow')
% for iXY = 1:size(dataloc.d,2)
%     if ~isempty(dataloc.d{iXY})
%         nexttile
%         tklg = ((sum((~isnan(dataloc.d{iXY}.data.XCoord)),2,'omitnan')))/100;
%         scatter(mean(dataloc.d{iXY}.data.XCoord,2,'omitnan'),mean(dataloc.d{iXY}.data.YCoord,2,'omitnan'),tklg,"filled")
%         title(['XY ' num2str(iXY)])
%     end
% end
% %%
% figure
% scatter(mean(dataloc.d{3}.data.XCoord,2,'omitmissing'),mean(dataloc.d{3}.data.YCoord,2,'omitmissing'),sum(~isnan(dataloc.d{3}.data.XCoord),2),"filled")

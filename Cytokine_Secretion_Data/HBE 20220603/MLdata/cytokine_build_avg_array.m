
%% Script to make avg arrary from pre-segmented microarray spots
% Can pull individual #s with slight modification

basefolder = ['\\albecklab.mcb.ucdavis.edu\data\data2\Notebooks\Devan\Cytokines\HBE 20220603\MLdata\'];
membranes = {'Membrane1_365\', '\Membrane2_366\', '\Membrane3_367\', '\Membrane4_368\', ...
    '\Membrane5_201\', '\Membrane6_202\', '\Membrane7_203\', '\Membrane8_204\'};
load('\\albecklab.mcb.ucdavis.edu\data\data2\Notebooks\Devan\Cytokines\HBE 20220603\MLdata\all_targets.mat')

A = NaN(numel(membranes), numel(all_targets));
raw_vals = NaN(numel(membranes), numel(all_targets), 2);
data_ch = 'Ch800_Nuc'; %order in the valcube (800 nuc is 2)
data_bkg = 'Ch800_Cyt'; %order in the valcube (800 nuc is 2)

for j = 1: numel(membranes)
    load([basefolder membranes{j} 'Membrane 1.mat'])
    vc_ch = strcmp(data_ch, vcorder);
    vc_bkg = strcmp(data_bkg, vcorder);
    for jj = 1:numel(all_targets)
        curr_t = all_targets{jj};
        cyt_idx = strcmp(curr_t, {CytokineInfo.Target});
        if sum(cyt_idx)~=2
            warning([curr_t ' has more than 2 data points'])
        end
        dp = [valcube(cyt_idx, 1, vc_ch)- valcube(cyt_idx, 1, vc_bkg)];
        if numel(dp)>2
            warning(['Skipping ' curr_t ' raw data entry to matrix'])
        else
            raw_vals(j, jj, :) = dp;
        end
        avg_val = mean(dp, 'omitnan');
        A(j, jj) = avg_val;
    end
end

CytOrd_cols = all_targets;
% save for later reference! This is the conditions of the membranes (from
% notebook. Manual annotation
MemCond_rows = {'Veh_Veh_365'; 'EGF_IL1b_366'; 'Veh_IL1b_367'; 'EGF_PolyIC_368';...
    'PDEGF_IL1b_201'; 'MK_IL1b_202'; 'Metform_IL1b_203'; 'NoGluc_IL1b_204'};

%%
save('MicroArrayData', 'A', 'CytOrd_cols', 'MemCond_rows')

%% Graph just IL8
%standard deviation instead
col = 65;

figure('Position', [500 500 300 300]); 
bar(A(:,col))
xticklabels(replace(MemCond_rows, '_', ' '))
yline(A(1,65), '--')
hold on
er_var = std(raw_vals(:,col,:), 0, 3, 'omitnan');
er = errorbar(1:8, A(:,65), er_var, "LineStyle","none", "LineWidth", 1); 
ylabel('Spot Intensity (a.u.)')
title('Supernatant IL8')
% for ii = 1:2
%     %scatter(1:8, raw_vals(:, col, ii), 30, 'k', 'filled', ...
%         'MarkerEdgeColor','r', 'MarkerFaceAlpha',.2) %funny but no
% end

%% Ken's microarray graph
Kd = readtable('\\albecklab.mcb.ucdavis.edu\data\data2\Notebooks\Devan\Cytokines\Copy of Devan HBE  Milliplex 12 16 21.xlsx',...
    'Sheet', 'MLdata');
IL8_data = Kd.IL8;
IL6_data = Kd.IL6;
MCP1_data = Kd.MCP1;

rel_cds = [1,3,4,6];

cyt_mat = [IL8_data, IL6_data, MCP1_data]';

figure('Position', [500 500 300 250]); bar(cyt_mat(:,rel_cds), .85)
xticklabels({'IL8', 'IL6', 'MCP1'})
legend(replace(Kd.Treatment(rel_cds), '_', ' '), 'Location', 'north')
ylabel('Cytokine Conc. (pg/mL)'); yticks([0:2000:6000])
title('HBE1 Supernatant ELISA')


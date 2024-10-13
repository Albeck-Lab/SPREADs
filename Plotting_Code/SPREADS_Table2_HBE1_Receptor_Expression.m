%% Table 2 - HBE1 RNAseq Receptor expression
% We want to get the mean normalized read counts of the receptor components that are expressed in the 
% HBE1 cells. We have data from 3 technical replicates (AZHBE1-3). We will check for the all of the receptor components
% for ligands that were increased in secretion following IL-1b treatment (in HBE1 cells; Figure 4A).

% add the paths
addpath('Z:\Code\DatalocHandler\','Z:\Code\Cell Trace','Z:\Code\Image Analysis','Z:\Code\ARCOS-MATLAB\Source','Z:\imageData\SPREADs\RNAseq_Data')

%% HBE1 mean normalized read counts per million reads.

% First load the RNAseq data that was obtained by Ken on HBE1 cells treated with vehicle (other data was removed).
rnaSeqData = readtable('Z:\imageData\SPREADs\RNAseq_Data\normalized_counts_per_million_reads.txt');

% Get the mean normailzed counts per million reads of the 3 replicates and make it a new column
% AZHBE1, AZHBE2, and AZHBE3 are the vehicle treated HBE1 cells
rnaSeqData.mean = mean([rnaSeqData.AZHBE01,rnaSeqData.AZHBE02,rnaSeqData.AZHBE03],2,'omitnan');

% Now get the mean normalized read counts per million reads for the components of the receptors for the ligands that have increased secretion from IL1b treatment 
% (Identified in Figure 4A) and add EGF and EGFR for reference.
% 
% Cytokine:	                Receptor Genes:
% EGF                       EGFR (for reference)
% GROa (CXCL1)	            CXCR2
% IL-17a (CTLA8, CX2?)	    IL17R (IL17RA/B/C/D/E)
% IL-6	                    IL6R, gp130
% IL-8 (CXCL8)	            CXCR1/2
% MCP-1 (CCL2)	            CCR2 (CCR4)
% MIP-3a (CCL20)	        CCR6

% load the table of cytokine receptor pairs
cytoRec = readtable('Z:\imageData\SPREADs\RNAseq_Data\Cytokine_Recepter_Pairs.xlsx','Sheet','Sheet1')

% pull the receptor genes
rGenes = strsplit(strjoin(cytoRec.ReceptorGenes',', '),', ');


% find the RNAseq data that has the receptor genes
hasGene = matches(rnaSeqData.external_gene_name,rGenes,'IgnoreCase',true);

% pull the name and make a table that has the means
cytoRecData = table;
cytoRecData.GeneName = rnaSeqData.external_gene_name(hasGene);
cytoRecData.meanCount = rnaSeqData.mean(hasGene);
cytoRecData.GeneName = categorical(cytoRecData.GeneName,{'EGFR','CXCR2','IL17RA', 'IL17RB', 'IL17RC', 'IL17RD', 'IL17RE','IL6R','CXCR1','CCR2','CCR4','CCR6'});






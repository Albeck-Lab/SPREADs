
-------------------  Description of each files in the folder concerning RNAseq data -----------------------------

dds_ctrl.Rds-----------------------------------------------------------------------------------------------------

R DESeq2 object, contains the raw RNAseq data, metadata, GRanges and the DESeq and FPKM-normalized data.

HBE1_report_SPREADs_paper.Rmd------------------------------------------------------------------------------------

Code used for the entire data analysis, starting from the dds.Rds object

HBE1_report_SPREADs_paper.html-----------------------------------------------------------------------------------

Output of the Rmd code.

hsapiens_annotations_oct2024.Rds ---------------------------------------------------------------------------------

Rds file used to annotate the Ensembl data

Receptors_of_interest_FPKM_R_output.csv ---------------------------------------------------------------------------

Table containing all receptors of interest + annotation. A direct output of the Rmd report.

SPREADs_HBE1_RNAseq_FPKM_receptor_expression.xlsx -----------------------------------------------------------------

Table corresponding to Table 2 in the paper. Filtered verison of the previous file.
% 
% % Run the movie flattener on the submerged pHBE data to make LUTz look better
% moviePath = 'C:\Users\ndecuzzi\Desktop\fftest\test\2022-09-15_pHBE_EKAREN4_Cytokine Array_xy16_il1b.nd2';
% bkxy = 1;
% outPath = 'C:\Users\ndecuzzi\Desktop\fftest\test\ff_2022-09-15_pHBE_EKAREN4_Cytokine Array_xy16_il1b.nd2';
% 
% MovieFlattener(moviePath, bkxy, outPath)

addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick')
addpath('\\albecklab.mcb.ucdavis.edu\data\bfmatlab\')
addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Image Analysis\')
addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Cell Trace\')

moviePath = 'C:\Users\ndecuzzi\Desktop\fftest\test\2022-09-15_pHBE_EKAREN4_Cytokine Array_xy16_il1b.nd2';
bkxy = 1;
tifPath = 'D:\pHBE_Tiffs\singleTiffs\2022-09-15_phbe_ekaren4_cytokine array_xy16_il1b.tif';
outputFileName = 'D:\pHBE_Tiffs\fftest2_2022-09-15_phbe_ekaren4_cytokine array_xy16_il1b.tif';

MovieFlattener(moviePath, bkxy, tifPath, outputFileName)
%CELLTRACER_V2_SCRIPT
%downstairs scope 

function [ip, op] = celltracer_v2_2022_02_23_16HBE1_EKAR_Cyto_inhibs()

addpath('\\albecklab.mcb.ucdavis.edu\data\Code\Nick')

dataloc = DatalocHandler('initialize', true);
%Initialize Celltracer Parameter Structures
[ip, op] = celltracer_v2_partner('initialize');

%% Define Imaging Parameters
%   --------- EDIT THIS SECTION TO DEFINE THE IMAGE DATA ---------
%Data locations
%   Target imaging data file name (include path)
ip.fname = fullfile(dataloc.fold.im, dataloc.file.im);  
%   Target save name for processed data files (include path)
ip.sname = [dataloc.fold.proc, '\', dataloc.file.base];  

%Data - basic statistics
%   Provide the expected size of imaging data
ip.indsz.xy = [94];   %Number of XY positions
ip.indsz.z  = [1];   %Number of Z positions
ip.indsz.t  = [253];   %Number of Time points
ip.indsz.c  = [2];   %Number of color Channels
ip.tsamp    = [6];   %Time between samples (MUST BE FILLED)

%Note: the following flag may be set true for the (rare) instances of
%corrupt ND2 files where the XY and Time indices have be exchanges
ip.flipxyt = true;

%Data - detailed definitions
%   Provide the baseline image intensity value (from Camera)
ip.bval = 0;
%   Initialize the properly sized bkg structure
ip.bkg(ip.indsz.xy) = ip.bkg;   

%   Provide background regions or values for each XY position
[ip.bkg(94).reg]    = deal([1000, 1000; 1050, 1050]);

%Region (or fixed values)
[ip.bkg(:).fix]   = deal(false);	%Is .reg a fixed intensity value
[ip.bkg(:).dyn]    = deal(true);  	%Is this XY bkg dynamic (sample each frame)?

[ip.bkg([1:93]).altxy]  = deal([94]);     	%Index of alternate XY to use for bkg
[ip.bkg(94).bkonly] = deal(true);  	%Is this XY only for background
%       ***CRITICAL:  Ensure background information is properly defined!
%       We recommend using a background well, and setting all other wells'
%       .altxy field the to the index of the background well.

%   Provide expected (or measured) frame-shift events
ip.xyshift.frame = [13,32];      %Time indices of first shifted frames
ip.xyshift.dx    = [];      %x magnitude of shift (omit for tracking)
ip.xyshift.dy    = [];      %y magnitude of shift (omit for tracking)
ip.xyshift.trackwell = [];  %XY index for use in tracking
ip.xyshift.trackchan = [2];  %Channel to use in tracking
ip.xyshift.badtime   = [];  %Time points bad for tracking (optional)
ip.xyshift.shifttype = 'translation';  %Type of shift to perform

%   Provide backup imaging MetaData:
%       (** = Critical for all runs, ++ = Only for objbias)
    %   Parameters of the objective
    %   ---------------------------------------------------------------
    ip.bkmd.obj.Desc       =   'Apo_20x';  %Description of Objective
    ip.bkmd.obj.Mag        =   20;         %Magnification ++
    ip.bkmd.obj.WkDist     =   1;          %Working Distance (mm) ++
    ip.bkmd.obj.RefIndex   =   1;          %Index of Refraction ++
    ip.bkmd.obj.NA         =   0.75;       %Numerical Aperture ++
    %   Parameters of the camera
    %   ---------------------------------------------------------------
    ip.bkmd.cam.Desc       =   'Zyla5';    %Descriptor of camera
    ip.bkmd.cam.PixSizeX   =   0.65;       %Pixel horizontal size (um) **
    ip.bkmd.cam.PixSizeY   =   0.65;       %Pixel vertical size (um) **
    ip.bkmd.cam.PixNumX    =   1280;       %Number of Pixels in X **
    ip.bkmd.cam.PixNumY    =   1080;       %Number of Pixels in Y **
    ip.bkmd.cam.BinSizeX   =   2;          %Number of Pixels per bin, X
    ip.bkmd.cam.BinSizeY   =   2;          %Number of Pixels per bin, Y
    ip.bkmd.cam.CamSizeX   =   2560;       %Camera sensor X resolution *+
    ip.bkmd.cam.CamSizeY   =   2160;       %Camera sensor Y resolution *+
    %   Parameters of the exposures
    %   ---------------------------------------------------------------
    %   Declare here names for the color channels, in proper order.  
    %       All other entries in ip.bkmd.exp must be in the same order.
    ip.bkmd.exp.Channel    =   {'CFP', 'YFP'};  %Name(s) of Channel(s)
    
    %   ----- OPTIONAL - Only for use with Spectral Unmixing -----
    %   Declare the Filters for each Channel ++
    ip.bkmd.exp.Filter     =   {'Filter_CFPa', 'Filter_YFP'};
    %   Declare the target Fluorophores for each Channel ++
    ip.bkmd.exp.FPhore     =   {'mTurq2', 'YPet'};
    %       -> See iman_naming for valid Filter and Fluorophore Names    
    %   Declare the Channel names associate with each FRET pair
    %       (only needed for pixel-by-pixel spectral unmixing of FRET)
    ip.bkmd.exp.FRET       =   {};% struct('EKAR', {{'CFP','YFP'}}); % {[1,2]}
    ip.bkmd.exp.Light      =   'SPECTRAX_2021';           %Light source name ++
    ip.bkmd.exp.Exposure   =   {150, 250};  %Exposure times (ms) ++ % WAS 150,250
    ip.bkmd.exp.ExVolt     =   {15, 50};     %Relative voltage (0-100) ++
    %   IF using the SPECTRAX light source, also define the following:
      ip.bkmd.exp.ExLine     =   {[2],[4]};   %Excitation line
      ip.bkmd.exp.ExWL       =   {[440],[508]};   %Wavelength
    %   ----- ----------------------------------------------- -----


%Show final image parameters (Comment out the following to avoid printing)
display(ip);
fprintf('\nip.indsz = \n\n');  display(ip.indsz); 
fprintf('\nip.bkmd = \n\n');   display(ip.bkmd);
%   ------ ------ END OF IMAGE DATA DEFINITION SECTION ------ ------


%% Define Operation Parameters
%   -------- EDIT THIS SECTION TO SETUP THE PROCESSING RUN --------
%Procedure scope - target ranges of the data to process
op.cind     = [1:2];       %Indices of Channels to process (names or indices) 
op.xypos    = [90,94];       %Indices of XY positions to process
op.trng     = [1:253];       %Start and End indices of Time to process
op.nW       = 8;        %Number of parallel workers to use
%   Optional procedures
op.objbias  = true;     %Correct for objective view bias
op.flatten = false;    %Correct for flat-field defects, using background well
op.unmix    = false;  	%Linearly unmix color channel cross-talk
op.fixshift = true;  	%Correct any indicated frameshifts


%   Indicate which fields of bkmd should override any other MetaData source
%   (use when recorded MetaData are corrupted)
op.mdover   = {'exp', 'ExVolt'; 'exp', 'Exposure';'exp','Filter'; ...
    'exp','Channel'; 'exp','FPhore'; 'exp','Light'};

%Procedure settings ***CRITICAL - Review carefully
%%
%   Segmentation settings
op.seg.chan = [2];       %Color channel on which to segment  !!
%   A second seg channel may be given (opposite nuc/cyt of first), to
%   filter cyto masks. Use op.seg.cyt to specify the FIRST seg channel
op.seg.cyt  = false; 	%Segment on cytoplasmic signal      !!

% Nick Settings
op.seg.maxD = 25;       %Maximum nuclear diameter (um)
op.seg.minD = 6;      	%Minimum nuclear diameter (um)
%       It is recommended to scale imaging for nuclei (segmentation
%       targets) to be greater than 10 pixels in diameter.
op.seg.maxEcc = 0.98;    %Maximum eccentricity [0-1] (opposite of circularity)
op.seg.Extent = [0.6, 0.9]; %Minimum fraction of bounding box filled 
%   Extent range is [0-1], value for a cirlce is PI/4
op.seg.maxSmooth = 0.1;     %Maximum fraction of convex hull without mask

op.seg.sigthresh = [50]; %[Optional] Minimum intensity of 'good' signal
op.seg.hardsnr = false;  %Typically kept to FALSE.  TRUE makes the signal 
%   threshold 'hard', enforcing cutoff of any pixels below it.
op.seg.nrode = 1;  %[Optional] Approx. number of pixels to erode nuc mask
%   NOTE: op.seg.nrode is only to improved nearby cell separation - it is
%   undone in final masks.  Use op.msk.nrode to adjust final masks.

%    Masking settings
op.msk.rt = {};             %Pre-averaging channel ratios to take {{'',''}}
op.msk.storemasks = false;  %Save all segmentation masks
op.msk.saverawvals = true;  %Save all raw valcube entries (pre-tracking)

op.msk.nrode = 1;   %[Optional] Approx. # pixels to erode final nuc mask
op.msk.cgap = 0;    %[Optional] Approx. # pixels to expand nuc-cyt mask gap
op.msk.cwidth = 0;  %[Optional] Approx. # pixels to expand cyto ring width
op.msk.nfilt = false; %[Optional] TRUE to filter cyto mask by nuc channel
%   Removes cyto mask where nuc signal > 5th percentile of nuc channel
%   IF significant varied cyto staining in nuc channel, do not use
op.msk.cfilt = false; %[Optional] TRUE to filter cyto mask by cyt channel
%   Removes cyto mask where cyto signal is at background (below sigthresh)

% Tracking settings (for utrack)
%   Typically, these do not require editing
op.trk.linkrad = 10;        % Radius (in um) to consider for frame-to-frame 
                            %   linking of cell movement
op.trk.minTrkLength = 5;    % Minimum number of consecutive frames required
                            %   for a track to be used in gap closing
op.trk.gaprad = 15;         % Radius (in um) for gap closing
op.trk.gapwin = 60;         % Time window (in minutes) for gap closing
op.trk.msRadMult = 1;       % Multiplier for search radius when finding 
                            %   merges and splites (Keep at 1 if tracking
                            %   splits is not critical. If increased, run
                            %   validation GUI to check flagged splits for
                            %   real/fake.

%   Display settings - select which options to show while running
op.disp.meta     = false;       %Final MetaData to be used
op.disp.samples  = true;       %Sparse samples of segmentation
op.disp.shifts   = false;       %Shifted images
op.disp.warnings = false;       %Procedural warning messages


%Show final operation parameters (uncomment to show)
% display(op);
% fprintf('\nop.seg = \n\n');  display(op.seg); 
% fprintf('\nop.disp = \n\n');  display(op.disp); 
%   ------ ------ END OF PROCESSING RUN SETUP SECTION ------ ------

%   Do NOT edit the following parameter transfers
op.cname    = ip.bkmd.exp.Channel;  %Copy channel names to op
op.msk.fret = ip.bkmd.exp.FRET;     %Copy FRET channel names to op


%% Run image analysis procedure
%Pre-Run validation
[ip, op] = celltracer_v2_partner('validate', ip, op);
%Optional segmentation check
%   Run the following commented function to view segmentation based on
%   current parameters.  Type help iman_segcheck for more details.  op
%   settings can then be adjusted and iman_segcheck rerun to test. Do not
%   reset pst to empty - it is needed to avoid reloading of the dataset.
% pst = [];
% pst = iman_segcheck(ip, op, 't',20, 'xy',20, 'pastinfo',pst);
% figgies = findobj('Type', 'figure');
% set(figgies(1),'Position', [0, 0, 1280, 1080]); saveas(figgies(1), [dataloc.fold.fig, '\', 'segcheck_cyt_xy20_t20_nrode', num2str(op.msk.nrode), '_cgap', num2str(op.msk.cgap), '_cwidth', num2str(op.msk.cwidth), '.png'])
%
%Optional tracking check
%   Run the following, after editing the time range ('t') and potentially
%   the range of frames ('frm') to plot ('splits' instructs the routine to
%   plot the frame before and after any track split).  Reset d.tF to empty
%   to rerun u-track if op.trk parameters have been changed.  Do not reset
%   d = [] - it is needed to avoid reloading of the dataset and rerunning
%   segmentation.
% d = []; %<- Use for first run.  
% %  d.tF = [];% <- Use after setting op.trk
% d = iman_trkcheck(ip, op, d, 't',30:50, 'npth',10, 'frm','splits');
%
%  After running, can use the following to run segview
%   iman_segview(ip.sname,1,1,'printid',true,'idcolor',[0,0,0]);


%% Main procedure
[dao, GMD, dmx] = iman_celltracer(ip, op);



end




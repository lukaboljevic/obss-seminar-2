% Read (and convert to double) one of the images from CTMRI DB. Also set
% specific sigmaPercent (what percentage of the minimum of image dimensions
% to take as sigma) and threshold values for each subject.

% Subject 1 (not easy images!)
% image = "S1-first-602-0006.png";  % ~1.5; ~2-8
% image = "S1-first-602-0019.png";  % ~1.5; ~2-8
% sigmaPercent = 0.006;
% threshold = 1.5;
% TL = 2;
% TH = 8;


% Subject 2 (these two slices come from `3D-images` and `3D-images-2`)
% image = "S2-first-2-0017.png";  % ~25; ~12-42
image = "S2-first-4-0101.png";  % ~25; ~15-45
sigmaPercent = 0.005;
threshold = 25;
TL = 15;
TH = 45;


% Subject 3.1
% image = "S3-first-2-0002.png";  % ~20; ~12-40
% image = "S3-first-2-0016.png";  % ~20; ~12-40
% sigmaPercent = 0.005;
% threshold = 20;
% TL = 12;
% TH = 40;

% Subject 3.2
% image = "S3-first-603-0034.png";  % ~15; ~10-25
% image = "S3-first-603-0110.png";  % ~15; 10-25
% sigmaPercent = 0.005;
% threshold = 15;
% TL = 10;
% TH = 25;


% Do Marr-Hildreth with or without edge linking. Optionally thin the edges
thin = true;
save = false;
plot = true;

marr("images", image, sigmaPercent, threshold, save, plot);
marrLinking("images", image, sigmaPercent, TL, TH, thin, save, plot);


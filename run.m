% Read (and convert to double) one of the images from CTMRI DB. Also set
% specific sigmaPercent (what percentage of the minimum of image dimensions
% to take as sigma) and threshold values for each subject.

% Subject 1 (not easy images!)
% image = "S1-first-602-0006.png";  % 0.006, 2, 8 works I think
image = "S1-first-602-0019.png";  % similar as above I think
sigmaPercent = 0.006;
threshold = 1.5;
TL = 2;
TH = 8;

% Subject 2.1
% image = "S2-first-2-0017.png";
% sigmaPercent = 0.005;
% threshold = 22;
% TL = 12;
% TH = 42;

% Subject 2.2
% image = "S2-first-2-0017.png";  % ~ 10, 25
% image = "S2-first-2-0017.png";  % ~ 10, 25
% sigmaPercent = 0.005;
% threshold = 15;
% TL = 10;
% TH = 25;

% Subject 3
% image = "S3-first-2-0002.png";  % 12, 40
% image = "S3-first-2-0016.png";  % 12, 40
% sigmaPercent = 0.005;
% threshold = 20;
% TL = 12;
% TH = 40;


% Do Marr-Hildreth with or without edge linking. Optionally thin the edges
thin = false;
save = false;
plot = true;

% marr("images", image, sigmaPercent, threshold, save, plot);
marrLinking("images", image, sigmaPercent, TL, TH, thin, save, plot);


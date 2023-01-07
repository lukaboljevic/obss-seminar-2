% Set constants
imageFolder = "3D-images";  % "3D-images" or "3D-images-2"
sigmaPercent = 0.005;
if imageFolder == "3D-images"
    TL = 12;
    TH = 42;
else
    TL = 15;
    TH = 45;
end
thin = true;


% Show original images in 3D
images = dir(strcat(imageFolder, '/*.png'));  % ignore . and ..
original = {};
k = 1;
for i=1:length(images)
    if contains(images(i).name, "_")
        % ignore files where edges were detected
        continue
    end

    fName = strcat(imageFolder, '/', images(i).name);
    original{k} = im2double(imread(fName));
    k = k + 1;
end
original3d = cat(3, original{:});
volumeViewer(original3d);
% for a nicer view of the head, under "Layout" tab -> Default -> Stack 2D slices


% Do 3D Marr-Hildreth
[slices] = marr3D(imageFolder, sigmaPercent, TL, TH, thin);
slices3d = cat(3, slices{:});


% Show the result

% I - individual slices
figure;
imshow3D(slices3d, [], 1);


% II - montage
% if thin
%     count = 1;
%     step = 9;
%     for i=1:step:length(slices)
%         figure;
%         montage(slices, Indices=i:min(i+step, length(slices)));
%         title(sprintf("Montage #%d", count));
%         count = count + 1;
%     end
% else
%     montage(slices);
% end


% III - actual 3D
volumeViewer(slices3d);

% When Volume Viewer App opens, do the following:
%   - under "Layout" tab -> Default -> Stack 2D slices, for a nicer view
%   - under "Rendering Editor", keep "Isosurface" but change color to some
%   light gray, and set isovalue to lowest possible, OR
%   - under "Rendering Editor", select "Volume Rendering", set alphmap to
%   something nicer, turn off "Lighting" at the end. OR

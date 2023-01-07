function [result] = marr(imageFolder, imageName, sigmaPercent, threshold, save, plot)
% Perform original Marr-Hildreth edge detection

    imageName = convertStringsToChars(imageName);

    % Read and convert to double
    imgpath = strcat(imageFolder, "/", imageName);
    image = im2double(imread(imgpath));
    [height, width] = size(image);
    
    % sigma parameter for the Gauss filter is usually 0.5% of the minimum 
    % of the two image dimensions in pixels, but we can specify a different
    % percentage
    sigma = sigmaPercent * min(height, width);
    
    % Calculate LoG kernel
    kernel = calcLoG(sigma);
    
    % LoG of image
    logimage = conv2(image, kernel, "same");
    
    % Zero crossing detection (from lecture notes)
    zerosimage = zeros(height, width);
    for i=2:height-1
        for j=2:width-1
            okay = 0;
            hood = logimage(i-1:i+1, j-1:j+1);
            shood = sign(hood);
            
            % Take 0 to be positive (i.e. sign = 1)
            shood(shood == 0) = 1;
            
            % Left, right
            if (shood(2, 1) ~= shood(2, 3)) && (abs(hood(2, 1) - hood(2, 3)) > threshold)
                okay = okay + 1;
            end

            % Up, down
            if (shood(1, 2) ~= shood(3, 2)) && (abs(hood(1, 2) - hood(3, 2)) > threshold)
                okay = okay + 1;
            end

            % Top left, bottom right
            if (shood(1, 1) ~= shood(3, 3)) && (abs(hood(1, 1) - hood(3, 3)) > threshold)
                okay = okay + 1;
            end

            % Top right, bottom left
            if (shood(1, 3) ~= shood(3, 1)) && (abs(hood(1, 3) - hood(3, 1)) > threshold)
                okay = okay + 1;
            end
    
            if okay >= 2
                % edge pixel!
                zerosimage(i, j) = 1;
            end
        end
    end
    
    % Show result
    if plot
        f = figure(); subplot(1, 2, 1); imshow(image, []); title("Original image");
        subplot(1, 2, 2); imshow(zerosimage, []); title("Detected edges, T = " + threshold);
        f.WindowState = "maximized";
    end
    result = zerosimage;

    % Save
    if save
        outputFile = strcat(imageFolder, "/", imageName(1:end-4), "_" , ...
            num2str(sigmaPercent), ",", num2str(threshold), ".png");
        imwrite(result, outputFile);
    end
end
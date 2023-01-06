function [result] = marrLinking(imageFolder, imageName, sigmaPercent, TL, TH, thin, save, plot)
% Perform improved Marr-Hildreth edge detection
% Improvements are: (1) using strong and weak edge pixels, i.e. a high and
% low threshold, which is an idea taken from Canny edge detection, and (2)
% edge linking using 8-connectivity. Optionally, the detected edges can be
% thinned.

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
    
    % Zero crossing detection using strong and weak pixels, i.e. two
    % different thresholds - the idea was taken from Canny's edge detection
    % algorithm.
    strong = zeros(height, width);
    weak = zeros(height, width);
    for i=2:height-1
        for j=2:width-1
            okayStrong = 0;
            okayWeak = 0;
            hood = logimage(i-1:i+1, j-1:j+1);
            shood = sign(hood);
            
            % Take 0 to be positive (i.e. sign = 1)
            shood(shood == 0) = 1;
            
            % Left, right
            if (shood(2, 1) ~= shood(2, 3))
                diff = abs(hood(2, 1) - hood(2, 3));
                if diff > TH
                    okayStrong = okayStrong + 1;
                elseif diff > TL
                    okayWeak = okayWeak + 1;
                end
            end

            % Up, down
            if (shood(1, 2) ~= shood(3, 2))
                diff = abs(hood(1, 2) - hood(3, 2));
                if diff > TH
                    okayStrong = okayStrong + 1;
                elseif diff > TL
                    okayWeak = okayWeak + 1;
                end
            end

            % Top left, bottom right
            if (shood(1, 1) ~= shood(3, 3))
                diff = abs(hood(1, 1) - hood(3, 3));
                if diff > TH
                    okayStrong = okayStrong + 1;
                elseif diff > TL
                    okayWeak = okayWeak + 1;
                end
            end

            % Top right, bottom left
            if (shood(1, 3) ~= shood(3, 1))
                diff = abs(hood(1, 3) - hood(3, 1));
                if diff > TH
                    okayStrong = okayStrong + 1;
                elseif diff > TL
                    okayWeak = okayWeak + 1;
                end
            end

            if okayStrong >= 2
                strong(i, j) = 1;
            elseif okayWeak >= 2
                weak(i, j) = 1;
            end
        end
    end
    
    % Show initial strong and weak pixels
%     f1 = figure(); subplot(1, 3, 1); imshow(image, []); title("Original image");
%     subplot(1, 3, 2); imshow(strong, []); title("Strong pixels, TH = " + TH);
%     subplot(1, 3, 3); imshow(weak, []); title("Weak pixels, TL = " + TL);
%     f1.WindowState = "maximized";

    % Perform edge linking using 8-connectivity
    while 1
        weakConnected = 0;
        for i=2:height-1
            for j=2:width-1
                if weak(i, j) == 0
                    continue
                end
                strongHood = strong(i-1:i+1, j-1:j+1);
                if sum(strongHood(:)) >= 1
                    % if this weak pixel is directly connected (based on
                    % 8-connectivity) to a strong pixel, then unmark it as
                    % weak, and mark it as strong
                    weakConnected = 1;
                    weak(i, j) = 0;
                    strong(i, j) = 1;
                end
            end
        end
        if ~weakConnected
            % we link edges until there are weak pixels that can connect to
            % strong ones
            break
        end
    end

    % Show result edge linking (and optionally, thin the edges).
    if plot
        f2 = figure(); subplot(1, 2, 1); imshow(image, []); title("Original image");
        subplot(1, 2, 2); imshow(strong, []); title("Detected edges after linking, TH = " + TH + ", TL = " + TL);
%         subplot(1, 3, 3); imshow(bwmorph(strong, "thin"), []); title("Edge thinning");
        f2.WindowState = "maximized";
    end
    result = strong;

    % Optionally thin the edges
    if thin
        result = bwmorph(strong, 'thin');
    end

    % Save
    if save
        outputFile = strcat(imageFolder, "/", imageName(1:end-4), "_" , ...
            num2str(sigmaPercent), ",", num2str(TL), "-", num2str(TH), ".png");
        % CHANGE WHAT WE'RE SAVING
        imwrite(strong, outputFile);
    end
end



function [slices] = marr3D(imageFolder, sigmaPercent, TL, TH, thin)
% Perform Marr-Hildreth edge detection in 3D

    % Get all images
    images = dir(strcat(imageFolder, '/*.png'));

    % Read already existing files, or detect edges
    slices = {};
    k = 1;
    for i=1:length(images)
        if contains(images(i).name, "_")
            % skip images where edges are detected, we just want the originals
            continue
        end

        fName = sprintf("%s/%s_%.3f,%d-%d.png", imageFolder, ...
            images(i).name(1:end-4), sigmaPercent, TL, TH);

        if ~isfile(fName)
            % Detect edges first
            disp("Detecting edges for " + images(i).name + "...");
            [result] = marrLinking(imageFolder, images(i).name, sigmaPercent, TL, TH, false, true, false);
            slices{k} = result;
            k = k + 1;
        else
            % We already detected edges for these parameter settings
            disp("Edges detected: " + fName);
            slices{k} = im2double(imread(fName));
            k = k + 1;
        end
    end
    
    % Do edge linking with 24 connectivity between consecutive image slices. 
    [height, width] = size(slices{1});
    
%     for curr=1:length(marrImages)-1  % forwards
    for curr=length(slices):-1:2  % backwards
        img1 = slices{curr};  % image "n"

        % Pad the above (or below) image with zeros so we can look at a 5x5
        % neighborhood. This is image "n+1".
%         img2 = marrImages{curr+1};  % forwards
        img2 = slices{curr-1};  % backwards
        paddedImg2 = padarray(img2, [1 1], 0, 'both');

        for i=2:height-1
            for j=2:width-1
                if img1(i, j) == 0
                    continue
                end

                % Check if pixel directly above is 1
                if img2(i, j) == 1  % has to be i+1, j+1 because we padded img2 with zeros
                    continue
                end

                % Check if any pixel in 3x3 neighborhood above is 1
                hood = img2(i-1:i+1, j-1:j+1);
                if sum(hood(:)) >= 1
                    continue
                end

                % Check if all pixels in 5x5 neighborhood above are 0.
                % Due to padding, the actual pixel we want to be centered
                % around is at i+1,j+1, not i,j
                hood = paddedImg2((i+1)-2:(i+1)+2, (j+1)-2:(j+1)+2);
                if sum(hood(:)) == 0
                    continue
                end
                
                % Perform linking for this 5x5 neighborhood. ih and jh
                % stand for "i hood" and "j hood"
                for ih=(i+1)-2:(i+1)+2
                    for jh=(j+1)-2:(j+1)+2
                        if paddedImg2(ih, jh) == 0
                            continue
                        end

                        % Move towards the center of the 5x5 neighborhood,
                        % and set each pixel (in the original img2) on the
                        % shortest path to 1.
                        a = ih; b = jh; 
                        while a ~= (i+1) || b ~= (j+1)
                            if a ~= (i+1)
                                a = a + move(a, i+1);  % increase or decrease a, depending on the position relative to the center
                            end

                            if b ~= (j+1)
                                b = b + move(b, j+1);
                            end
                            img2(a-1, b-1) = 1;  % set the corresponding pixel in original img2 to 1
                        end

                    end  % jh loop
                end  % ih loop

            end  % j loop
        end  % i loop

        % Update, so it can be used in the next iteration
%         marrImages{curr+1} = img2;  % forwards
        slices{curr-1} = img2;  % backwards
    end  % outside for loop

    % Optionally, thin the resulting images
    if thin
        for i=1:length(slices)
            slices{i} = bwmorph(slices{i}, 'thin');
        end
    end
end


function [res] = move(current, center)
    if current > center  % we're below or right of center
        res = -1;
    elseif current < center  % we're above or left of center
        res = +1;
    end
end
% Read the MRI image
grayImage = imread('tumor.jpg');
%grayImage=rgb2gray(grayImage);
% Display the original image
subplot(2, 2, 1); imshow(grayImage);
title('Original Image');

% Preprocess the image
filteredImage = medfilt2(grayImage, [3, 3]);

% Display the filtered image
subplot(2, 2, 2); imshow(filteredImage);
title('Filtered Image');

binaryImage = imbinarize(filteredImage);

% Display the binary image
subplot(2, 2, 3);imshow(binaryImage);
title('Binary Image');

% Remove small noise and fill holes
binaryImage = bwareaopen(binaryImage, 150);
binaryImage = imfill(binaryImage, 'holes');

% Display the cleaned binary image
subplot(2, 2, 4); imshow(binaryImage);
title('Cleaned Binary Image');

% Find tumor regions
stats = regionprops(binaryImage, 'Area', 'BoundingBox', 'Centroid');

% Initialize variables to store tumor information
tumorCount = 0;
tumorAreas = [];
tumorCentroids = [];

% Specify the size range for tumors
minTumorArea = 200;
maxTumorArea = 5000;

% Analyze each region
for i = 1:numel(stats)
    if (stats(i).Area >= minTumorArea) && (stats(i).Area <= maxTumorArea)
        tumorCount = tumorCount + 1;
        tumorAreas(tumorCount) = stats(i).Area;
        tumorCentroids(tumorCount, :) = stats(i).Centroid;
    end
end

% Display the original image
figure; subplot(1, 2, 1); imshow(grayImage);
title('Original Image');

if tumorCount == 0
    % No tumor detected
    subplot(1, 2, 2);imshow(grayImage);
    title('No Tumor Detected');
else
    % Mark detected tumors
    subplot(1, 2, 2);imshow(grayImage); % Display on the original image
    hold on;
    for i = 1:tumorCount
        text(tumorCentroids(i, 1), tumorCentroids(i, 2), ['Tumor ', num2str(i)], 'Color', 'r');
        rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
    end
    hold off;
end

% Display results
if tumorCount == 0
    fprintf('No tumor detected.\n');
else
    fprintf('Detected %d tumors.\n', tumorCount);
    fprintf('Tumor Areas: %s\n', mat2str(tumorAreas));
end

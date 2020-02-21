function bse(imgFileName, phi, varargin)
%BSE Blind Source Extraction
%   This function mixes the given image with noise and trie to recover the image
%   from the noisy mixtures.
%
% INPUT
%   imgFileName             image file
%   phi                     mixing angle
%   darkeningLevel (opt)    used to conceals the image in the noise
%
% OUTPUT
%   No output.
%
% ============================================================================ %

% Creates bse-tmp dir 
if(~exist('bse-tmp', 'dir'))
    try
        mkdir('bse-tmp');
    catch
        error("Could not create the bse-tmp directory.");
    end
end

%
% Image
%

% Check if the image exists
if(~exist(imgFileName, 'file'))
    error("Image doesn't exist.");
end

% Read the image
img = imread(imgFileName);

sz = size(img);
if(numel(sz) == 3)
    img = rgb2gray(img);
end
img = mat2gray(img);

[height, width] = size(img);

%
% Darkening
%
switch nargin
    case 3
        darkeningLevel = varargin{1};
        img = darkening(img, darkeningLevel);     
end

%
% Noisy image (gray scale)
%
noisyImg = generatenoisyimg(height, width);

%
% Mixing process
%
x = mixing(img, noisyImg, phi);

%
% BSE process (kind of a brute force)
%
theta = linspace(0, pi, 1441);

complexity = zeros(numel(theta), 1);
minComplexity = inf;

fprintf("Progress: ")

for i = 1:numel(theta)
    % Progress
    count = fprintf('%.2f%%', i*100/numel(theta));
    
    % Extraction vector
    w = [cos(theta(i)), sin(theta(i))];
    
    % Recovered signal
    y = w*[x(1, 1:end); x(2, 1:end)];
    
    % Array to matrix (now y is 2-dimensional)
    y = mat2gray(reshape(y, height, width));

    % Save TIFF image with no compression
    imwrite(y, 'bse-tmp/img-tmp.tiff', 'tiff', 'Compression', 'none');
    fidu = dir('bse-tmp/img-tmp.tiff');
    
    % Save TIFF image with compression (lossless data compression)
    imwrite(y, 'bse-tmp/img-tmp.tiff', 'tiff', 'Compression', 'lzw');
    fidc = dir('bse-tmp/img-tmp.tiff');
    
    complexity(i) = fidc.bytes/fidu.bytes;
    
    if(complexity(i) < minComplexity)
        minComplexity = complexity(i);
        yrec = y;
    end
    
    if(i*100/numel(theta) < 100)
        for iCount = 1:count
            fprintf('\b');
        end
    else
        fprintf("\n");
    end
end % END bse()

%
% Figures
%

% Save images
if(exist('darkeningLevel', 'var'))
    imwrite(reshape(img, height, width), 'bse-tmp/img-darkened.png', 'png');    
end

imwrite(reshape(noisyImg, height, width), 'bse-tmp/noise.png', 'png');
imwrite(reshape(x(1, 1:end), height, width), 'bse-tmp/img-mixed-1.png', 'png');
imwrite(reshape(x(2, 1:end), height, width), 'bse-tmp/img-mixed-2.png', 'png');
imwrite(yrec, 'bse-tmp/img-rec.png', 'png');

% Plot images
fh = figure;

if(exist('darkeningLevel', 'var'))
    subplot(4, 2, 1)
    img = imread(imgFileName);
    imshow(img)
    title("original")

    subplot(4, 2, 2)
    img = imread('bse-tmp/img-darkened.png', 'png');
    imshow(img)
    title(sprintf("darkened: %.1f%%", darkeningLevel*100))

    subplot(4, 2, [3, 4])
    img = imread('bse-tmp/noise.png', 'png');
    imshow(img)
    title("noise")

    subplot(4, 2, 5)
    img = imread('bse-tmp/img-mixed-1.png', 'png');
    imshow(img)
    title("mixed 1")

    subplot(4, 2, 6)
    img = imread('bse-tmp/img-mixed-2.png', 'png');
    imshow(img)
    title("mixed 2")

    subplot(4, 2, [7, 8])
    img = imread('bse-tmp/img-rec.png', 'png');
    imshow(img)
    title("recovered")
else
    subplot(3, 2, 1)
    img = imread(imgFileName);
    imshow(img)
    title("original")

    subplot(3, 2, 2)
    img = imread('bse-tmp/noise.png', 'png');
    imshow(img)
    title("noise")

    subplot(3, 2, 3)
    img = imread('bse-tmp/img-mixed-1.png', 'png');
    imshow(img)
    title("mixed 1")

    subplot(3, 2, 4)
    img = imread('bse-tmp/img-mixed-2.png', 'png');
    imshow(img)
    title("mixed 2")

    subplot(3, 2, [5, 6])
    img = imread('bse-tmp/img-rec.png', 'png');
    imshow(img)
    title("recovered")
end

set(fh, 'Position', [110, 75, 430, 600])

print(fh, "1.png", '-dpng');

% Complexity
fh = figure;

hold on
plot(theta, complexity)
oldYLim = get(gca, 'YLim');
plot([phi, phi], oldYLim, 'r:')
hold off

grid on

xlim([min(theta), max(theta)])
ylim(oldYLim)
xlabel('\theta (rad)')
ylabel('complexity(\theta)')

set(gca, 'XTick', [0, pi/6, pi/3, pi/2, 2*pi/3, 5*pi/6, pi], ...
    'XTickLabel', {'0', '\pi/6', '\pi/3', '\pi/2', '2\pi/3', '5\pi/6', '\pi'})

set(fh, 'Position', [675, 150, 560, 420])

print(fh, "2.png", '-dpng');

%
% Delete files and folders
%
delete('*.asv', '*.m~')
rmdir('bse-tmp', 's')

end

function darkenedImg = darkening(img, darkeningLevel)
    % Check darkeningLevel
    if(darkeningLevel < 0 || darkeningLevel >= 1)
        error(["Value of darkeningLevel must be a number in the", ...
            "interval (0, 1["]);
    end
    
    %
    % Darkening process
    %
    if(exist('darkeningLevel', 'var'))
        if(darkeningLevel ~= 0)
            darkenedImg = (1 - darkeningLevel)*img;
        end
    end
end % END darkening()

function noisyImg = generatenoisyimg(height, width)
    noisyImg = rand(height, width);         % uniform distribution
    noisyImg = mat2gray(noisyImg);
end % END generatenoisyimg()

function x = mixing(sourceImg, noisyImg, phi)
    % Matrix to array
    sourceImg = reshape(sourceImg, 1, []);
    noisyImg  = reshape(noisyImg, 1, []);

    % Mixing matrix
    A = [cos(phi), -sin(phi);
         sin(phi),  cos(phi)];

    % Mixed images (array)
    x = A*[sourceImg; noisyImg];
    x(1, 1:end) = mat2gray(x(1, 1:end));
    x(2, 1:end) = mat2gray(x(2, 1:end));
end % END mixing()

%% BLIND SOURCE EXTRACTION BASED ON KOLMOGOROV-CHAITIN COMPLEXITY
%
%   Examples of blind source extraction (BSE) based on Kolmogorov-Chaitin
%   complexity, which is estimated by means of lossless compression of data (in
%   this case, we use the LZW compression of TIFF images). To perform the BSE,
%   we assume that the mixtures are more complex (i.e., can be less compressed)
%   than the source image.
%
%   The scenario is as follows:
%       * A is the full rank mixing matrix, which is given by:
%
%           A = [cos(\theta)  -sin(\theta)
%                sin(\theta)   cos(\theta)]
%
%       * w is the extraction vector, which is:
%
%           w = [cos(\phi)  sin(\phi)]^T.
%
%   Before applying the mixing process, the images are converted to 1-D arrays.
%   Thus, we have:
%
%           x = A*s,
%
%   where x corresponds to the mixed images and s are the souces (one is the
%   image of interest and the other is a noisy image).
%   The extraction process is given by:
%
%           y = w*x
%
%   where y is the recovered image.
%
% REFERENCES
%   P. Pajunen, "Blind source separation using algorithmic information theory",
%       Neurocomputing, v. 22, 1-3, p. 35-48, 1998. DOI: 
%       doi.org/10.1016/S0925-2312(98)00048-4.
%   D. C. Soriano, R. Suyama, and R. Attux, "Blind extraction of chaotic sources
%       from mixtures with stochastic signals based on recurrence quantification
%       analysis", Digital Signal Processing, v. 21, 3, p. 417-426, 2011.
%
% CONTACT
%   Patrick Franco Coutinho
%   pfcoutinho@outlook.com
%
% Last update: Feb 20, 2020
% ============================================================================ %

close all
clear
clc

% Mixing angle phi (choose any value between 0 and pi)
phi = pi/4;

% Darkening level (value must be in the interval [0,1[)
darkeningLevel = 0.9;

%
% BSE
%
fprintf("Image #1: QR Code\n");
bse('imgs/qr-code.png', phi, darkeningLevel);

fprintf("\nImage #2: @ Sign\n");
bse('imgs/at-sign.png', phi, darkeningLevel);

fprintf("\nImage #3: Photo of Mt. Fuji\n");
bse('imgs/mt-fuji.jpg', phi);       % no darkening

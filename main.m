%% Blind source extraction (BSE) of images based on complexity measure
% Examples of blind source extraction (BSE) based on Kolmogorov-Chaitin
% complexity, which is estimated by means of lossless compression of data.
%
% Please, refer to the README for more information.
%
% CONTACT
%   Patrick Franco Coutinho
%   pfcoutinho@outlook.com
%
% Last update: Mar 14, 2020
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

fprintf("\nImage #3: Photography of the Mt. Fuji\n");
bse('imgs/mt-fuji.jpg', phi);       % no darkening

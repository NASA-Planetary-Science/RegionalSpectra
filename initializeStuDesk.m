SlepianDirectory='/home/alainplattner/Desktop/research/Slepian';


setenv('IFILES',fullfile(SlepianDirectory,'IFILES'))
setenv('OSTYPE','linux')
%setenv('OSTYPE','solaris')
%disp('If you are using a Solaris machine, change the OSTYPE setting in initialize.m')


addpath(fullfile(SlepianDirectory,'slepian_alpha'))
addpath(fullfile(SlepianDirectory,'slepian_alpha/REGIONS'))
addpath(fullfile(SlepianDirectory,'slepian_bravo'))
addpath(fullfile(SlepianDirectory,'slepian_charlie'))
addpath(fullfile(SlepianDirectory,'slepian_delta'))
addpath(fullfile(SlepianDirectory,'slepian_echo'))
addpath(fullfile(SlepianDirectory,'slepian_golf'))
addpath(fullfile(SlepianDirectory,'slepian_hotel'))
addpath(fullfile(SlepianDirectory,'slepian_hotel/MGS'))
addpath(fullfile(SlepianDirectory,'grdwrite2p'))
addpath(fullfile(SlepianDirectory,'nonZonalSlepians'))
addpath(fullfile(SlepianDirectory,'localDataSpec'))

addpath(fullfile(SlepianDirectory,'equalAreaSubsampling'))
addpath(fullfile(SlepianDirectory,'equalAreaSubsampling','spheretri'))

%addpath('/home/alainplattner/Desktop/MySoftware/Git/Slepian/prismSlepians')

%addpath('../RegionalSpecCodes_PutOnGitHub')

% Download the CHAOS-7 coefficients for testing
%urlwrite('http://www.spacecenter.dk/files/magnetic-models/CHAOS-7/CHAOS-7.2.mat','CHAOS-7.2.mat');

% At the moment CHAOS-6 is easier to cite. Doesn't matter which one we use
urlwrite('http://www.spacecenter.dk/files/magnetic-models/CHAOS-6/CHAOS-6-x9.mat','CHAOS-6-x9.mat');

% Also, get Purucker's field to compare to Voorhies+2002 results. This is
% just for testing
urlwrite('https://core2.gsfc.nasa.gov/research/purucker/br_spoabgt3_mars_rdipole_200km_1500cf_clip.xyz','br_spoabgt3_mars_rdipole_200km_1500cf_clip.xyz');

% Must also get Cain?

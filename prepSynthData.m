function prepSynthData(planet,addstrdata)

  % Simulate tracks by having finer lat spacing
  % These numbers are in degrees distance between points

  
  if strcmp(planet, 'Earth')
    TH = 90;%120;
    rotcoord = [0,60];
    %lonshift=0;
    Lmax = 20;%13;
    rplanet = 6371;
    alt = 300;
    altvar = 50;
    % For Earth lower res because only looking at core field
    reslon = 5;
    reslat = 1;
    % Load model
    coefsO = loadEarthCoef(Lmax,'CHAOS-6-x9.mat');
    coefsS = Olsen2Simons(coefsO)*rplanet;
    noiselevel = 0.20;
    Ltap=2;
    lrng = Ltap+1:Lmax-Ltap;

  elseif strcmp(planet,'Core')
    % A synthetic core field
    TH = 120;
    rotcoord = [0,60];
    %lonshift=0;
    Lmax = 20;
    rplanet = 6371;
    alt = 300;
    altvar = 50;
    % For Earth lower res because only looking at core field
    reslon = 5;
    reslat = 1;
    % Create model
    rtrue = 3480;
    spc = McLeod(rtrue, rplanet, rplanet, Lmax, 0);
    % Get normalization
    coefsO = loadEarthCoef(Lmax,'CHAOS-6-x9.mat');
    spcE = plm2spec(coef2lmcosi(coefsO,0),1);
    spc = spc*bestA(spc(2:end),spcE(2:end));
    [coefsO,coefsS] = createRandCoef(spc, Lmax, rplanet);
    noiselevel = 0.05;
    Ltap=2;
    lrng = Ltap+1:Lmax-Ltap;
    
  elseif strcmp(planet, 'Mars')
    TH = 20;
    %lonshift = -180;
    rotcoord = [200,159];
    Lmax = 90;
    rplanet = 3390;
    alt= 300;
    altvar = 50;
    % For Mars higher res, because looking at crustal field
    reslon = 1;
    reslat = 0.2;
    % Load model
    coefsO = Cain2003();
    coefsS = Olsen2Simons(coefsO)*rplanet;
    % Need to put in rotation. This is only for this specific model:
    [~,~,~,~,~,~,bigm] = addmon(90);
    coefsS = coefsS.*((-1).^bigm(:));
    Ltap = 8;
    lrng = Ltap+1:Lmax-Ltap;
    noiselevel = 0.1;

  elseif strcmp(planet, 'MarsNew')
    TH = 20;
    %lonshift = -180;
    rotcoord = [200,159];
    Lmax = 134;
    rplanet = 3393.5;
    alt= 0;%300;
    altvar = 0;%50;
    % For Mars higher res, because looking at crustal field
    reslon = 1;
    reslat = 0.2;
    %reslon = 0.4;
    %reslat = 0.4;
    % Load model
    cf = load('Lang2019.mat');
    coefsS = cf.coef;
    coefsO = Simons2Olsen(coefsS/rplanet);
    Ltap = 8;
    lrng = Ltap+1:Lmax-Ltap;
    noiselevel = 0.1; %0.02; %0.1;


  elseif strcmp(planet, 'Crust')
    TH = 20;
    %lonshift = -180;
    rotcoord = [200,159];
    Lmax = 134;
    rplanet = 3393.5;
    alt= 300;%0;%300;
    altvar = 50;%0;%50;
    % For Mars higher res, because looking at crustal field
    reslon = 1;
    reslat = 0.2;
    % Create model
    rtrue = 3300;
    spc = SRD(rtrue, rplanet, rplanet, Lmax, 0);
    % Get normalization
    % cf = load('Lang2019.mat');
    % coefsS = cf.coef;
    % coefsO = Simons2Olsen(coefsS/rplanet);
    % spcM = plm2spec(coef2lmcosi(coefsO,0),1);
    % spc = spc*bestA(spc(2:end),spcM(2:end));
    % [coefsO,coefsS] = createRandCoef(spc, Lmax, rplanet);
    load('crustmodel.mat')
    Ltap = 8;
    lrng = Ltap+1:Lmax-Ltap;
    noiselevel = 0.1;

    % Must save model. Otherwise it is gone...
    %save('crustmodel.mat','coefsO','coefsS')


  elseif strcmp(planet, 'MarsNewLarger')
    %%% Idea: Solve for TH = 30 and then look at spec for TH=20
    TH = 30;
    THspec = 20;
    %lonshift = -180;
    rotcoord = [200,159];
    Lmax = 134;
    rplanet = 3393.5;
    alt= 0;%300;
    altvar = 0;%50;
    % For Mars higher res, because looking at crustal field
    reslon = 1;
    reslat = 0.2;
    %reslon = 0.4;
    %reslat = 0.4;
    % Load model
    cf = load('Lang2019.mat');
    coefsS = cf.coef;
    coefsO = Simons2Olsen(coefsS/rplanet);
    Ltap = 8;
    lrng = Ltap+1:Lmax-Ltap;
    noiselevel = 0.1;


    
  else
    error('Planet must either be Earth or Mars or Core')

  end



  
  % Create synthetic locations
  lonedge = 0:reslon:360;
  colaedge = reslat:reslat:180-reslat;

  [lon,cola] = meshgrid(lonedge,colaedge);
  lon = lon(:);
  cola = cola(:);
  
  % Cut out data outside of region
  index = cut2cap2(lon, 90-cola, TH, rotcoord(1), 90-rotcoord(2));
  lon = lon(index);
  cola = cola(index);
  
  rad = rplanet + alt + altvar*rand(size(lon));
  %plot(lon,cola,'.'); axis ij;

  % Evaluate the synthetic locations
  B = rGvec(coefsS(:), cola*pi/180, lon*pi/180, rad, rplanet);
keyboard
  Br = B(1:length(lon));
  Br = Br + noiselevel*std(Br)*randn(size(Br)); 

  Bt = B(length(lon)+1:2*length(lon));
  Bt = Bt + noiselevel*std(Bt)*randn(size(Bt));

  Bp = B(2*length(lon)+1:end);
  Bp = Bp + noiselevel*std(Bp)*randn(size(Bp));

  %if strcmp(planet, 'Mars')
  %  lon = lon - lonshift;
  %  lon = mod(lon,360);
  %end

  %keyboard

  
  dlmwrite(fullfile('GMTdata',sprintf('synth_%s%s.txt',planet,addstrdata)), [rad, cola, lon, Br(:), Bt(:), Bp(:)], 'delimiter', '\t' )

  % Also write out expected spectrum and local spectrum

  %% Expected spectrum
  lmcosiO = coef2lmcosi(coefsO,0);
  specML = plm2spec(lmcosiO,1);
  ls = (0:Lmax)';
  specPD = specML(:)./(ls(:)+1)./(2*ls(:)+1);
  specPD_exp = localizeSpec(specPD,Ltap)'*spharea(THspec,1);
  specML_exp = specPD_exp(:).*(ls(:)+1).*(2*ls(:)+1);
  dlmwrite(fullfile('GMTdata','examples',sprintf('expectedspec_%s.txt',planet)), [(0:Lmax)',specML_exp(:)]);

  

  
  %% Get localized spectrum

  localspecML = localspectrum(coef2lmcosi(coefsS/sqrt(4*pi)),...
                              Ltap,THspec,[],rotcoord,[],[],2,rplanet);

  if strcmp(planet,'Mars') | strcmp(planet,'MarsNew') | strcmp(planet,'Crust') | strcmp(planet,'MarsNewLarger')
    rstart = 1000;
    rs = findDepthMinDiff_SRD(localspecML,lrng,rplanet,rplanet,rstart,Ltap,Lmax)
  else
    rstart = 1000;
    rs = findDepthMinDiff_McLeod(localspecML,lrng,rplanet,rplanet,rstart,Ltap,Lmax)
  end
  
  dlmwrite(fullfile('GMTdata','examples',sprintf('localspec_%s.txt',planet)), [(0:Lmax)',localspecML(:)]);

  
  
  % localspec has the correct power. specML_exp is for the whole planet, so not
  % representative of localspecML. It is weaker because Mars' magnetic field
  % is weaker in the northern hemisphere
 
  

function expectedLoc(planet)
  % Compares the expected local spectrum to the true local spectrum for a region
  % This is Figure 2 in the paper
  %
  % Lmax     Maximum spherical harmonic degree 
  % TH       cap opening angle
  % Ltap     tapering bandwidth
  % planet   Earth or Mars


%expectedLoc(Lmax,TH,Ltap,planet)
  
  switch planet
    case 'Earth'
      Lmax = 13;
      TH = 20;
      Ltap = 3;
      rotcoord = [0,30];
      rplanet = 6371.2;
      ls = 0:Lmax;
      % Import coefficients (Olsen normalization)
      coefsO=loadEarthCoef(Lmax,'CHAOS-6-x9.mat');
      lmcosiO=coef2lmcosi(coefsO,0);
      coefsS=Olsen2Simons(coefsO)*rplanet;
      lmcosiS=coef2lmcosi(coefsS,0);
    case 'MarsNew'
      rotcoord = [200,159];
      rplanet = 3393.5;
      Lmax = 134;
      TH = 20;
      Ltap = 3;
      cf = load('Lang2019.mat');
      coefsS = cf.coef; %/rplanet; %*sqrt(4*pi);
      coefsO = Simons2Olsen(coefsS/rplanet);
      %coefsO = Simons2Olsen(coefsS);
      lmcosiO=coef2lmcosi(coefsO,0);
      lmcosiS=coef2lmcosi(coefsS,0);
      ls = 0:Lmax;
  end
  

  
  % Calculate global spectrum (Mauersberger-Lowes)
  specML=plm2spec(lmcosiO,1);

  % Get expected local spectrum from the global spectrum
  % Our localizeSpec code requires the spectrum to be
  % differently normalized. Undo the ML normalization, then redo it
  specPD = specML(:)./(ls(:)+1)./(2*ls(:)+1);
  specPD_exp = localizeSpec(specPD,Ltap);
  specML_exp = specPD_exp(:).*(ls(:)+1).*(2*ls(:)+1);
  

  % Get the true local spectrum from the coefficients
  % Our code "localspectrum" needs the Simons normalization!
  locspecML = localspectrum(lmcosiS, Ltap, TH, [], rotcoord, [], [], 2, rplanet)/4/pi;
  % Normalize locspecML to the same area:
  locspecML = locspecML/spharea(TH,1);
  
  % Plot both
  semilogy(ls(2:end),specML_exp(2:end),'-')
  hold on
  semilogy(ls(2:end),locspecML(2:end),'--')
  semilogy(ls(2:end),specML(2:end),'xk')
  hold off
  
  % Save the specs for GMT plotting
  directory=fullfile('GMTdata','expectedSpec');
  filenameend=sprintf('%s_TH%g_rot%g_Lmax%d_Ltap%d',planet,TH,rotcoord(2),Lmax,Ltap);
  
  dlmwrite(fullfile(directory,['expected_',filenameend,'.txt']),[ls(:),specML_exp(:)])
  dlmwrite(fullfile(directory,['local_',filenameend,'.txt']),[ls(:),locspecML(:)])

  

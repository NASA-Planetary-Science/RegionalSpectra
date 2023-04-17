function [rs,localspecML,fitspec]=localSourceGlobModel(lrng)

  % Calculates the local spectrum, local source depth,
  % and best fitting SRD spec for the given lrng for
  % The model of Langlais+2019

  THspec = 20;
  rotcoord = [200,159];
  Lmax = 134;
  rplanet = 3393.5;
  Lmax = 134;
  Ltap = 8;
  cf = load('Lang2019.mat');
  coefsS = cf.coef;
  coefsO = Simons2Olsen(coefsS/rplanet);

  localspecML = localspectrum(coef2lmcosi(coefsS/sqrt(4*pi)),...
                              Ltap,THspec,[],rotcoord,[],[],2,rplanet);

  rstart = 1000;
  rs = findDepthMinDiff_SRD(localspecML,lrng,rplanet,rplanet,rstart,Ltap,Lmax);

  fitspec = SRD(rs,rplanet,rplanet,Lmax,Ltap);
  fitspec = bestA(fitspec(lrng+1),localspecML(lrng+1))*fitspec;

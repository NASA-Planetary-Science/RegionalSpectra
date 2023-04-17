function boxcarSpec()

  % Let's create a regular grid and set values outside of a simple
  % region to zero and inside to 1.

  Lmax=50;
  lon = 0:1:360;
  lat = 89:-1:-89;

  [LO,LA] = meshgrid(lon,lat);

  F = zeros(size(LO));
  
  % Make rectangular region
  indx = (lon > 20) & (lon < 170);
  indy = (lat > 10) & (lat < 60);

  F(indy,indx) = 1;
  
  subplot(3,1,1)
  imagesc(F)
  axis equal
  axis tight
  
  lmcosi = xyz2plm(F,Lmax);
  subplot(3,1,2)
  plotplm(lmcosi,[],[],4,1)

  spc = plm2spec(lmcosi);
  subplot(3,1,3)
  semilogy(0:Lmax,spc)
  %plot(0:Lmax,spc)
  xlabel('spherical harmonic degree')
  ylabel('power spectrum')
  
  %axis xy

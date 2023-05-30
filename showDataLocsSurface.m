function showDataLocsSurface()

  %rplanet = 3390;
  rplanet = 3393.5;
  
  % Load data
  data = load(fullfile('GMTdata','synth_MarsNew_surface_noise10p.txt'));
  rad = data(:,1);
  cola = data(:,2);
  lat = 90-cola;
  lon = data(:,3);
  Br = data(:,4);
  Bt = data(:,5);
  Bp = data(:,6);
  
  
  % Export full data locations
  filename = fullfile('GMTdata','synth_MarsNew_surface_noise10pc_gmtloc.txt')
  dlmwrite(filename, [lon,lat,Br]);

  

  
  % For 20% subsampling (alt1):
  nsph = 1000;
  npts = 25;
  [indx,pcount] = eqAreaSubs(lon,90-cola,nsph,npts);
  filename = fullfile('GMTdata','synth_MarsNew_surface_noise10pc_sub20_gmtloc.txt')
  dlmwrite(filename, [lon(indx),lat(indx),Br(indx)]);
  % Export subsampled 1 (24%)
  %alongtr = 1.5;  
  %betweentr = 10;
  %indx = subsampleDataTrackgapAlt(lon,90-cola,rad-rplanet,...
  %                                alongtr,betweentr,rplanet);
  

  % For 30% subsampling (alt2)
  nsph = 1000;
  npts = 38;
  [indx,pcount] = eqAreaSubs(lon,90-cola,nsph,npts);
  filename = fullfile('GMTdata','synth_MarsNew_surface_noise10pc_sub30_gmtloc.txt')
  dlmwrite(filename, [lon(indx),lat(indx),Br(indx)]);
  % Export subsampled 2 (12%)
  %alongtr = 3;
  %betweentr = 10;
  %indx = subsampleDataTrackgapAlt(lon,90-cola,rad-rplanet,...
  %                                alongtr,betweentr,rplanet);


  % For 10% subsampling (alt3)
  nsph = 1000;
  npts = 12;
  [indx,pcount] = eqAreaSubs(lon,90-cola,nsph,npts);
  filename = fullfile('GMTdata','synth_MarsNew_surface_noise10pc_sub10_gmtloc.txt')
  dlmwrite(filename, [lon(indx),lat(indx),Br(indx)]);

function meanModelCrust(altnr,addstrdata,addstrsav)
  % Calculates mean and std of range of models from data subselection

  defval('addstrdata','_noise10pc')
  defval('addstrsav',addstrdata)
  
  rplanet = 3393.5;
  
  res = 0.2;
  lon = 0:res:360-res;
  lat = -89.99:res:-40;
  %lat = -90+res:res:-40;
  [LON,LAT] = meshgrid(lon,lat);
  LON=LON(:); LAT = LAT(:);
  rad = rplanet*ones(size(LON));
  
  % Load many models
  switch altnr
    case 1
      load(['manysynth_Crust',addstrdata,'.mat']);
    case 2
      load(['manysynth_Crust',addstrdata,'_alt.mat']);
    case 3
      load(['manysynth_Crust',addstrdata,'_alt2.mat']);
  end

  coefs = cell2mat(coef);

  B = rGvec(coefs, (90-LAT)*pi/180, (LON*pi/180), rad, rplanet);

  Br = B(:,1:length(LON));
  Bth = B(:, length(LON)+1:2*length(LON));
  Bph = B(:, 2*length(LON)+1:end);

  Br_mean = reshape(mean(Br),length(lat),length(lon));
  Bth_mean = reshape(mean(Bph),length(lat),length(lon));
  Bph_mean = reshape(mean(Bth),length(lat),length(lon));

  Br_std = reshape(std(Br),length(lat),length(lon));
  Bth_std = reshape(std(Bph),length(lat),length(lon));
  Bph_std = reshape(std(Bth),length(lat),length(lon));
  
  switch altnr
    case 1
      filename = ['synthCrust',addstrsav,'_meanmodel.mat'];
    case 2
      filename = ['synthCrust',addstrsav,'_meanmodel_alt.mat'];
    case 3
      filename = ['synthCrust',addstrsav,'_meanmodel_alt2.mat'];
  end

  save(filename,'lon','lat', 'Br_mean', 'Bth_mean', 'Bph_mean', 'Br_std', 'Bth_std', 'Bph_std');

  
   
  


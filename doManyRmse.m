function doManyRmse(planet,whichsub)

%%% This is for MarsNew at altitude
  %sf = [0.3:0.025:0.7];
  %addstrdata =  '_noise10pc'
  
%%% This is for MarsNew on surface
  %sf = [0.5:0.1:1.5];
  sf = [1.2:0.025:1.7];
  addstrdata = '_surface_noise10p';
  %sf = 1.3:0.025:1.8;
  %sf = 1.2:0.1:2;
  %addstrdata = '_newsampling_surface_2p';
  alt=0; % Surface
  
  nruns = 100;
  %nruns = 15;
  %nruns = 2;

  rmse = nan(nruns, length(sf));
  
  j=1; rmse(j,:) = getrmse(planet, sf, addstrdata ,whichsub, alt);
  clear j;

  parfor j=2:nruns
    rmse(j,:) = getrmse(planet, sf, addstrdata ,whichsub, alt);
  end

  
  try
  switch whichsub
    case 1
      save(['manyrmse_',planet,addstrdata],'sf', 'rmse')
    case 2
      save(['manyrmse_',planet,addstrdata,'_alt'],'sf', 'rmse')
    case 3
      save(['manyrmse_',planet,addstrdata,'_alt2'],'sf', 'rmse')
  end
  
  catch
    keyboard
  end

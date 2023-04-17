function doManyRmseCrust(whichsub)


  sf = 1.1:0.025:2.2;
  addstrdata =  '_surface_noise10p';
  alt=0;
  nruns = 15;
  %nruns = 3;
  savstr = '_different_fewruns';
  
  rmse = nan(nruns, length(sf));

  % j=1;
  % rmse(j,:) = getrmse('Crust', sf, addstrdata ,whichsub,alt);
  % clear j;

  
  parfor j=1:nruns
    rmse(j,:) = getrmse('Crust', sf, addstrdata ,whichsub,alt);
  end

  try
  switch whichsub
    case 1
      save(['manyrmse_Crust',addstrdata,savstr],'sf', 'rmse')
    case 2
      save(['manyrmse_Crust',addstrdata,savstr,'_alt'],'sf', 'rmse')
    case 3
      save(['manyrmse_Crust',addstrdata,savstr,'_alt2'],'sf', 'rmse')
  end
  
  catch
    keyboard
  end

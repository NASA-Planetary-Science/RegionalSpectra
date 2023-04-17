function doManySynthCrust()

  whichsub=2;
  
  nruns = 100;

%%% For synthetic crust with zero altitude
  addstrdata = '_surface_noise10p';
  addstrsav = addstrdata;
  if whichsub==2
    sf = 1.575;
  end


  
  alt=0;

  
  parfor i=1:nruns
    [rs{i},invspecML{i},coef{i}] = solveSynth('Crust', sf, true, false, i, addstrdata, addstrdata,whichsub,alt)
  end

  switch whichsub
    case 1
      save(['manysynth_Crust',addstrsav],'rs', 'invspecML', 'coef')
    case 2
      save(['manysynth_Crust',addstrsav,'_alt'],'rs', 'invspecML', 'coef')
    case 3
      save(['manysynth_Crust',addstrsav,'_alt2'],'rs', 'invspecML', 'coef')
  end

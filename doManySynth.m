function doManySynth(whichsub)

  nruns = 100;

  %%% For Cain Mars
  % switch whichsub
  %   case 1
  %     sf = 1.05;
  %   case 2
  %     sf = 1.05;
  %   case 3
  %     sf = 1;
  % end
  % alt=300;

%%% For Langlais Mars
  % addstrdata = '_noise10pc';
  % switch whichsub
  %   case 1
  %     sf = 0;
  %   case 2
  %     sf = 0.5;
  %   case 3
  %     sf = 0.425;
  % end
  % alt=300;

%%% For Mars with zero altitude
  % addstrdata = '_surface_noise10p';
  % addstrsav = addstrdata;
  % if whichsub==2
  %   sf = 1.5;
  % end

%%% For Larger Mars with zero altitude
  addstrdata = '_surface_noise10p';
  addstrsav = addstrdata;
  if whichsub==2
    sf = 1.3250;
  end
  planet = 'MarsNewLarger'

  alt=0;

  
  parfor i=1:nruns
    [rs{i},invspecML{i},coef{i}] = solveSynth(planet, sf, true, false, i, addstrdata, addstrdata,whichsub,alt)
  end

  switch whichsub
    case 1
      save(['manysynth_',planet,addstrsav],'rs', 'invspecML', 'coef')
    case 2
      save(['manysynth_',planet,addstrsav,'_alt'],'rs', 'invspecML', 'coef')
    case 3
      save(['manysynth_',planet,addstrsav,'_alt2'],'rs', 'invspecML', 'coef')
  end

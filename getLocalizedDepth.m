function rs=getLocalizedDepth(planet)
  % Calculates the depth of the localized spectrum (from the global model)

  if strcmp(planet,'MarsNew')
    Lmax = 134;
    Ltap = 8;
    %lrng = Ltap+1:80;
    lrng = Ltap+1:85;
    rstart = 1000;
    rplanet = 3393.5;
  elseif strcmp(planet,'Earth')
    
  end
  
  spec = load(fullfile('GMTdata','examples','localspec_MarsNew.txt'));
  ls = spec(:,1);
  spc = spec(:,2);
  clear spec;

  if  strcmp(planet,'MarsNew')
    rs = findDepthMinDiff_SRD(spc,lrng,rplanet,rplanet,rstart,Ltap,Lmax);
  elseif strcmp(planet,'Earth')
    
  end

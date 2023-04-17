function rs = getAllDepths(planet,addstrdata,lrng)
  % Calculates and saves the source depths of the random subsampling spectra
  defval('addstrdata','_noise10pc')

  var=1;
  
  nr=100;

  Lmax = 134;
  Ltap = 8;

  % This for 10%
  %lrng = Ltap+1:80;
  
  % This for 30%
  %lrng = Ltap+1:85;
  
  % This for surface 30%
  %lrng = Ltap+1:Lmax-Ltap;
    
    
  rstart = 1000;
  rplanet = 3393.5;
  %if var==1
  foldername = ['manySpecs_',planet,addstrdata,'_alt'];
  %else
  %  foldername = sprintf(['manySpecs_',planet,addstrdata,'_alt%d'],var);
  %end


  rs=nan(nr,1);
  for i=1:nr
    spec = load(fullfile('GMTdata','examples',foldername,sprintf('spec%d.txt',i)));
    ls = spec(:,1);
    spc = spec(:,2);
    clear spec;

    rs(i) = findDepthMinDiff_SRD(spc,lrng,rplanet,rplanet,rstart,Ltap,Lmax);
    
  end

  dlmwrite(fullfile('GMTdata','examples',['rs_',foldername,'.txt']),[zeros(size(rs)),rs], 'precision','%f3'); 

  % Create average spec and best-fitting spec to average spec
  r1 = load(['manysynth_',planet,addstrdata,'_alt']);
  meanspc1 = mean(cell2mat(r1.invspecML),2);
  rs1 = findDepthMinDiff_SRD(meanspc1,lrng,rplanet,rplanet,rstart,Ltap,Lmax);
  fitspec1 = SRD(rs1,rplanet,rplanet,Lmax,Ltap);
  fitspec1 = bestA(fitspec1(lrng+1),meanspc1(lrng+1))*fitspec1;
  filename = fullfile('GMTdata','examples',['avgfit_manySpecs_',planet,addstrdata,'_alt.txt']);
  dlmwrite(filename,[(0:134)',fitspec1(:)], 'precision','%f3');

  
  %dlmwrite(fullfile('GMTdata','examples',sprintf('radii_%s_sf%g%s.txt',planet,sf,addstr)),[zeros(size(rs)),rs])

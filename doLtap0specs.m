function doLtap0specs()
  % Tries our what we get for source depth and spectra if we just use the global spectrum for the regional solution instead of the multitaper spectrum.

  Ltap = 0;
  THspec = 20;
  rotcoord = [200,159];
  rplanet = 3393.5;
  Lmax = 134;
  rstart = 1000;

  wht = 1;
  
  switch wht

    case 1

      load('manysynth_MarsNew_noise10pc_alt.mat');
      savename = 'manySpecs_MarsNew_noise10pc_alt_Ltap0';
      mkdir(fullfile('GMTdata','examples',savename));
      domarea = spharea(THspec,1);
      lrng = 9:85;
      rs = nan(length(coef),1);
      meanspc = zeros(Lmax+1,1);

      coef = coef;
      
      parfor i=1:length(coef)

        invspecML = localspectrum(coef2lmcosi(coef{i}/sqrt(4*pi)),Ltap,THspec,[],rotcoord,[],[],2,rplanet);
        invspecML = invspecML/domarea; % This is to normalize the global spectrum similar to the local spectrum
        % save
        saveitas = fullfile('GMTdata','examples',savename,sprintf('spec%d.txt',i));
        writematrix([(0:Lmax)',invspecML(:)],saveitas);
        
        meanspc = meanspc + invspecML;
        rs(i) = findDepthMinDiff_SRD(invspecML,lrng,rplanet,rplanet,rstart,Ltap,Lmax);
      end

try
      
      % Now save rs
      saveitas = fullfile('GMTdata','examples',['rs_',savename]);
      rs = rs(:);
      writematrix([zeros(size(rs)),rs],saveitas);

      % Now save fit to mean spectrum
      meanspc1 = meanspc/length(coef);  
      rs1 = findDepthMinDiff_SRD(meanspc1,lrng,rplanet,rplanet,rstart,Ltap,Lmax);
      fitspec1 = SRD(rs1,rplanet,rplanet,Lmax,Ltap);
      fitspec1 = bestA(fitspec1(lrng+1),meanspc1(lrng+1))*fitspec1;

      saveitas = fullfile('GMTdata','examples',['avgfit_',savename]);
      writematrix([(0:Lmax)',fitspec1(:)],saveitas);

catch
  keyboard
end
      
  end

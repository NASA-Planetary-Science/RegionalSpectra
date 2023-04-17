function write2GMT(wht,addstrdata,planet)

  defval('addstrdata','_noise10pc')
  defval('planet','MarsNew')

  alsosub10=false;
  
  switch wht
    case 'rmse'

      % r=load('manyrmse_MarsNew_noise10pc.mat');
      % Lmax=90;
      % J = round(spharea(20,1)*(Lmax+1)^2*r.sf);
      % for i=1:size(r.rmse,1)
      %   filename=fullfile('GMTdata','examples','manyrmse_MarsNew_noise10pc',...
      %                     sprintf('rmse%d.txt',i));
      %   dlmwrite(filename,[J(:), r.rmse(i,:)'])      
      % end
      % filename=fullfile('GMTdata','examples','manyrmse_MarsNew_noise10pc',...
      %                   'mean_rmse.txt');
      % dlmwrite(filename,[J(:), mean(r.rmse)']) 


      r=load(['manyrmse_',planet,addstrdata,'_alt.mat']);
      Lmax=134;
      J = round(spharea(20,1)*(Lmax+1)^2*r.sf);
      mkdir(fullfile('GMTdata','examples',['manyrmse_',planet,addstrdata,'_alt']))
      for i=1:size(r.rmse,1)
        filename=fullfile('GMTdata','examples',['manyrmse_',planet,addstrdata,'_alt'],...
                          sprintf('rmse%d.txt',i));
        dlmwrite(filename,[J(:), r.rmse(i,:)'])      
      end
      filename=fullfile('GMTdata','examples',['manyrmse_',planet,addstrdata,'_alt'],...
                        'mean_rmse.txt');
      dlmwrite(filename,[J(:), mean(r.rmse)'])

      
      % r=load(['manyrmse_MarsNew',addstrdata,'_alt2.mat']);
      % Lmax=134;
      % J = round(spharea(20,1)*(Lmax+1)^2*r.sf);
      % mkdir(fullfile('GMTdata','examples',['manyrmse_MarsNew',addstrdata,'_alt2']))
      % for i=1:size(r.rmse,1)
      %   filename=fullfile('GMTdata','examples',['manyrmse_MarsNew',addstrdata,'_alt2'],...
      %                     sprintf('rmse%d.txt',i));
      %   dlmwrite(filename,[J(:), r.rmse(i,:)'])      
      % end
      % filename=fullfile('GMTdata','examples',['manyrmse_MarsNew',addstrdata,'_alt2'],...
      %                   'mean_rmse.txt');
      % dlmwrite(filename,[J(:), mean(r.rmse)']) 


      
    case 'mean'

      % r = load('synthMarsNew_noise10pc_meanmodel.mat');
      % filename= fullfile('GMTdata','synthMarsNew_noise10pc_sub20_mean.grd')
      % grdwrite2p(r.lon,r.lat,r.Br_mean,filename)

      % filename= fullfile('GMTdata','synthMarsNew_noise10pc_sub20_std.grd')
      % grdwrite2p(r.lon,r.lat,r.Br_std,filename)
      
      r = load(['synth',planet,addstrdata,'_meanmodel_alt.mat']);
      filename= fullfile('GMTdata',['synth',planet,addstrdata,'_sub30_mean.grd'])
      grdwrite2p(r.lon,r.lat,r.Br_mean,filename)

      filename= fullfile('GMTdata',['synth',planet,addstrdata,'_sub30_std.grd'])
      grdwrite2p(r.lon,r.lat,r.Br_std,filename)

      if alsosub10
        r = load(['synthMarsNew',addstrdata,'_meanmodel_alt2.mat']);
        filename= fullfile('GMTdata',['synthMarsNew',addstrdata,'_sub10_mean.grd'])
        grdwrite2p(r.lon,r.lat,r.Br_mean,filename)
        
        filename= fullfile('GMTdata',['synthMarsNew',addstrdata,'_sub10_std.grd'])
        grdwrite2p(r.lon,r.lat,r.Br_std,filename)
      end
        

      
    case 'Cain'
      % Write Cain model

      rplanet = 3390;
      coefsO = Cain2003();
      coefsS = Olsen2Simons(coefsO)*rplanet;
      % Need to put in rotation. This is only for this specific model:
      [~,~,~,~,~,~,bigm] = addmon(90);
      coefsS = coefsS.*((-1).^bigm(:));
      
      res = 0.2;
      lon = 0:res:360-res;
      lat = -89.99:res:-25;
      %lat = -90+res:res:-40;
      [LON,LAT] = meshgrid(lon,lat);
      LON=LON(:); LAT = LAT(:);
      rad = rplanet*ones(size(LON));

      B = rGvec(coefsS, (90-LAT)*pi/180, (LON*pi/180), rad, rplanet);

      Br = B(1:length(LON));

      index = cut2cap2(LON, LAT, 20, 200, 90-159);
      Br_cut = Br;
      Br_cut(~index) = 0;
      
      Br = reshape(Br,length(lat),length(lon));
      Br_cut = reshape(Br_cut,length(lat),length(lon));
      
      filename= fullfile('GMTdata','Cain_Br.grd');
      grdwrite2p(lon,lat,Br,filename)

      filename= fullfile('GMTdata','Cain_Br_cut.grd');
      grdwrite2p(lon,lat,Br_cut,filename)


      
    case 'Lang'
      % Write Langlais model
      
      rplanet = 3393.5;    
      cf = load('Lang2019.mat');
      coefsS = cf.coef;
       
      res = 0.2;
      lon = 0:res:360-res;
      lat = -89.99:res:-25;
      %lat = -90+res:res:-40;
      [LON,LAT] = meshgrid(lon,lat);
      LON=LON(:); LAT = LAT(:);
      rad = rplanet*ones(size(LON));

      B = rGvec(coefsS, (90-LAT)*pi/180, (LON*pi/180), rad, rplanet);

      Br = B(1:length(LON));

      index = cut2cap2(LON, LAT, 20, 200, 90-159);
      Br_cut = Br;
      Br_cut(~index) = 0;
      
      Br = reshape(Br,length(lat),length(lon));
      Br_cut = reshape(Br_cut,length(lat),length(lon));
      
      filename= fullfile('GMTdata','Lang_Br.grd');
      grdwrite2p(lon,lat,Br,filename)

      filename= fullfile('GMTdata','Lang_Br_cut.grd');
      grdwrite2p(lon,lat,Br_cut,filename)


 case 'Crust'
      % Write Langlais model
      
      rplanet = 3393.5;    
      cf = load('crustmodel.mat');
      coefsS = cf.coefsS;
       
      res = 0.2;
      lon = 0:res:360-res;
      lat = -89.99:res:-40;
      %lat = -90+res:res:-40;
      [LON,LAT] = meshgrid(lon,lat);
      LON=LON(:); LAT = LAT(:);
      rad = rplanet*ones(size(LON));

      B = rGvec(coefsS, (90-LAT)*pi/180, (LON*pi/180), rad, rplanet);

      Br = B(1:length(LON));

      index = cut2cap2(LON, LAT, 20, 200, 90-159);
      Br_cut = Br;
      Br_cut(~index) = 0;
      
      Br = reshape(Br,length(lat),length(lon));
      Br_cut = reshape(Br_cut,length(lat),length(lon));
      
      filename= fullfile('GMTdata','Crust_Br.grd');
      grdwrite2p(lon,lat,Br,filename)

      filename= fullfile('GMTdata','Crust_Br_cut.grd');
      grdwrite2p(lon,lat,Br_cut,filename)

      

    case 'specs'

      alt='';
      
      r = load(['manysynth_',planet,addstrdata,'_alt',alt]);
      %r = load('manysynth_noise10pc_alt');
      folder = fullfile('GMTdata','examples',['manySpecs_',planet,addstrdata,'_alt',alt])
      ls = 0:134;

      mkdir(folder)

      for i=1:length(r.invspecML)
        filename = fullfile(folder,sprintf('spec%d.txt',i));
        dlmwrite(filename,[ls(:), r.invspecML{i}])  
      end

      % % Also write out all the rs values
      % rs = cell2mat(r.rs);
      % filename = fullfile('GMTdata','examples',['rs_manySpecs_',planet,addstrdata,'_alt',alt,'.txt']);
      % rs = rs(:);
      % dlmwrite(filename,[zeros(size(rs)),rs]);

      warning('Need to run getAllDepths.m to calculate the rs values for a chose lrng')

    case 'meanspecfit'

      warning('Need to run getAllDepths.m to calculate the best fitting spec for the average local spec for the choice of lrng')
      
      % Ltap=8;
      % %lrng=Ltap+1:80;
      % lrng=Ltap+1:85;
      % rstart=1000;
      % rplanet=3393.5;
      % Lmax=134;
      
      % % Load spectra
      % r1 = load(['manysynth_',planet,addstrdata,'_alt']);
      % %r2 = load(['manysynth_MarsNew',addstrdata,'_alt2']);

      % % Calculate mean
      % meanspc1 = mean(cell2mat(r1.invspecML),2);
      % %meanspc2 = mean(cell2mat(r2.invspecML),2);

      % % Calculate best fitting
      % rs1 = findDepthMinDiff_SRD(meanspc1,lrng,rplanet,rplanet,rstart,Ltap,Lmax);
      % %rs2 = findDepthMinDiff_SRD(meanspc2,lrng,rplanet,rplanet,rstart,Ltap,Lmax);
      % fitspec1 = SRD(rs1,rplanet,rplanet,Lmax,Ltap);
      % fitspec1 = bestA(fitspec1(lrng+1),meanspc1(lrng+1))*fitspec1;

      % %fitspec2 = SRD(rs2,rplanet,rplanet,Lmax,Ltap);
      % %fitspec2 = bestA(fitspec2(lrng+1),meanspc2(lrng+1))*fitspec2;   

      % % write best fitting
      % filename = fullfile('GMTdata','examples',['avgfit_manySpecs_',planet,addstrdata,'_alt.txt']);
      % dlmwrite(filename,[(0:134)',fitspec1(:)]);

      % %filename = fullfile('GMTdata','examples',['avgfit_manySpecs_',planet,addstrdata,'_alt2.txt']);
      % %dlmwrite(filename,[(0:134)',fitspec2(:)]);
      
      
  end

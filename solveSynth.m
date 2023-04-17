function [rs,invspecML,coef] = solveSynth(planet, shanfact, subsample, export, number,addstr,addstrdata,whichsub, alt)

  if strcmp(planet, 'Earth')
    TH = 120;
    THspec=TH;
    rotcoord = [0,60];
    Lmax = 13;
    Ltap = 2;
    %Ltap = 1;
    rplanet = 6371;
    %alt = 300;
    % Need to pick good values
    alongtr = 8;
    betweentr = 1;
    %lrng = Ltap+1:Lmax-Ltap;
    lrng = 3:6;
    
  elseif strcmp(planet, 'Mars') | strcmp(planet,'MarsNew') | strcmp(planet,'Crust')
    TH = 20;
    THspec=TH;
    %lonshift = 0;
    rotcoord = [200,159];
    Ltap = 8;
    if strcmp(planet, 'Mars')
      rplanet = 3390;
      Lmax = 90;
    else
      rplanet = 3393.5;
      Lmax = 134;
    end
    %alt = 300;

%%% Subsampling
    switch whichsub
      case 1
        % For 20% subsampling:
        nsph = 1000;
        npts = 25;
      case 2
        % For 30% subsampling
        nsph = 1000;
        npts = 38;
      case 3
        % For 10% subsampling
        nsph = 1000;
        npts = 12;

        
        % For 25% subsampling:
        %nsph = 1000;
        %npts = 31;
    end

    lrng = Ltap+1:Lmax-Ltap;
    %%% Maybe play around with good range
    
    % This is the old stuff... Keeping as comment for now
    % Need to pick good values
    % For high res data, I got good values for 1.5(along) and 10(between).
    % 1.5 along and 10 between is about 24% data subselection
    %alongtr = 1.5;  
    %betweentr = 10;
    %In this case, use shanfact = 1.1 (from calcManyRmse results)
    
    % When trying a other option, just to test how consistent the results are:
    % This gives about 12% subsampling
    %alongtr = 3;
    %betweentr = 10;
    % In this case, use shanfact = 1 (from calcManyRmse results)



  elseif strcmp(planet,'MarsNewLarger')
    TH = 30;
    THspec = 20;
    rotcoord = [200,159];
    
    Ltap = 8;
    rplanet = 3393.5;
    Lmax = 134;
    
%%% Subsampling
    switch whichsub
      case 1
        % For ?% subsampling:
        nsph = 1000;
        npts = 25;
      case 2
        % For 26% subsampling but same distribution in smaller region as other test
        nsph = 1000;
        npts = 38;
      case 3
        % For ?% subsampling
        nsph = 1000;
        npts = 12;
    end
    lrng = Ltap+1:Lmax-Ltap;



    
  elseif strcmp(planet, 'Core1') | strcmp(planet, 'Core2')
    TH = 120;
    THspec=TH;
    rotcoord = [0,60];
    Lmax = 20;
    Ltap = 2;
    %Ltap = 1;
    rplanet = 6371;
    %alt = 300;
    % Need to pick good values
    alongtr = 8;
    betweentr = 1;
    %lrng = Ltap+1:Lmax-Ltap;
    if shanfact==1.2
      lrng = 3:5;
    else
      lrng = 3:10;
    end
    %  shanfact = 1.2; is ok
    % But maybe just do all: shanfact=2



    
  else
    error('Planet must either be Earth or Mars or Core1 or Core2')    
  end

  data = load(fullfile('GMTdata',sprintf('synth_%s%s.txt',planet,addstrdata)));
  rad = data(:,1);
  cola = data(:,2);
  lon = data(:,3);
  Br = data(:,4);
  Bt = data(:,5);
  Bp = data(:,6);

  if export
    dlmwrite( fullfile('GMTdata','examples',sprintf('plotting_%s_fulldata%s.txt',planet,addstr)),[lon,90-cola,Br]);
  end

  %length(lon)
  %[x,y,z] = sph2cart(deg2rad(lon),deg2rad(90-cola),1);
  %plot3(x,y,z,'.')

  % Invert:
  %%% First random subsampling
  if subsample
    %indx = subsampleDataTrackgapAlt(lon,90-cola,rad-rplanet,...
    %                                alongtr,betweentr,rplanet);
    [indx,pcount] = eqAreaSubs(lon,90-cola,nsph,npts);
    
    lon = lon(indx);
    cola = cola(indx);
    rad = rad(indx);
    Br = Br(indx);
    Bt = Bt(indx);
    Bp = Bp(indx);

    disp(sprintf('data subsampling retention %g', sum(indx)/length(indx)))
  end

  %keyboard
  
  % figure(1)
  % length(lon)
  % [x,y,z] = sph2cart(deg2rad(lon),deg2rad(90-cola),1);
  % plot3(x,y,z,'.')
  % figure(2)
  % plot(lon,cola,'.')
  % axis ij
  % return
  
  B{1} = Br; B{2} = Bt; B{3} = Bp; 

  maxJ = (Lmax+1)^2;
  J = min(round(shanfact*spharea(TH,1)*maxJ), maxJ);
  coef = LocalIntField(B, rad, cola*pi/180, lon*pi/180, TH, Lmax, J, rplanet, rplanet+alt, rotcoord);

  % Plot field
  %plotplm(coef2lmcosi(coef/sqrt(4*pi)),[],[],4,1)
  %hold on
  %plot(lon,90-cola,'.k','MarkerSize',10)
  %hold off

  if export
    fname =  fullfile('GMTdata','examples',sprintf('plotting_%s_model%s',planet,addstr)); 
    GMTexportfield2(coef/sqrt(4*pi), fname, rplanet, 0, 1, [0,0,360,-90], [], [], 0.5, 0);
  end
 
  
  % Get local power spectrum
  invspecML = localspectrum(coef2lmcosi(coef/sqrt(4*pi)),...
                            Ltap,THspec,[],rotcoord,[],[],2,rplanet);

  if export
    if number & subsample
      fname = fullfile('GMTdata','examples',sprintf('spec_%s_sf%g_nr%d%s.txt',planet,shanfact,number,addstr));
    else
      fname = fullfile('GMTdata','examples',sprintf('spec_%s_sf%g_alldata%s.txt',planet,shanfact,addstr));
    end
    dlmwrite(fname, [(0:Lmax)',invspecML])
  end
  
  % Get local source depth
  if strcmp(planet,'Earth') | strcmp(planet,'Core1') | strcmp(planet,'Core2')
    rstart = 1000;
    rs = findDepthMinDiff_McLeod(invspecML,lrng,rplanet,rplanet,rstart,Ltap,Lmax);
    
    fitspec = McLeod(rs,rplanet,rplanet,Lmax,Ltap);
    fitspec = bestA(fitspec(lrng),invspecML(lrng))*fitspec;
    
  elseif strcmp(planet,'Mars') | strcmp(planet,'MarsNew') | strcmp(planet,'Crust') | strcmp(planet,'MarsNewLarger')
    rstart = 1000;
    rs = findDepthMinDiff_SRD(invspecML,lrng,rplanet,rplanet,rstart,Ltap,Lmax);
    
    fitspec = SRD(rs,rplanet,rplanet,Lmax,Ltap);
    fitspec = bestA(fitspec(lrng),invspecML(lrng))*fitspec;
  end
    

  % plot spectrum
  %figure
  %semilogy(0:Lmax, invspecML)
  %hold on
  %semilogy(0:Lmax, fitspec, '--')
  %hold off

  
  %maxJ
  %J
  %lrng

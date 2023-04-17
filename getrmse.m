function rmse = getrmse(planet, shanfacts, addstrdata, whichsub,alt)
  % Use this function to choose a good sf value (or J value)
  % Make sure that the subsampling etc are the same as when using solveSynth
  
 if strcmp(planet, 'Earth')
    TH = 120;
    rotcoord = [0,60];
    Lmax = 13;
    Ltap = 2;
    %Ltap = 1;
    rplanet = 6371;
    %alt = 300;
    lrng = Ltap+1:Lmax-Ltap;
    %lrng = 3:6;

    switch whichsub
      case 1
        % For 20% subsampling:
        nsph = 100;
        npts = 8;
      case 2
        % For 30% subsampling
        nsph = 100;
        npts = 12;
      case 3
        % For 10% subsampling
        nsph = 100;
        npts = 4;
        % For 25% subsampling:
        %nsph = 1000;
        %npts = 31;
    end
        
  elseif strcmp(planet, 'Mars') | strcmp(planet,'MarsNew') | strcmp(planet,'Crust')
    TH = 20;
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



  elseif strcmp(planet,'MarsNewLarger')
    TH = 30;
    rotcoord = [200,159];
    
    Ltap = 8;
    rplanet = 3393.5;
    Lmax = 134;
    
    %alt = 300;
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

 %indx = subsampleDataTrackgapAlt(lon,90-cola,rad-rplanet,...
 %                                alongtr,betweentr,rplanet);

 [indx,pcount] = eqAreaSubs(lon,90-cola,nsph,npts);

 % The testing data
 lon_res = lon(~indx);
 cola_res = cola(~indx);
 rad_res = rad(~indx);
 Br_res = Br(~indx);
 Bt_res = Bt(~indx);
 Bp_res = Bp(~indx);

 % The solving data
 lon = lon(indx);
 cola = cola(indx);
 rad = rad(indx);
 Br = Br(indx);
 Bt = Bt(indx);
 Bp = Bp(indx);

 

 B{1} = Br; B{2} = Bt; B{3} = Bp;

 maxJ = (Lmax+1)^2;

 for i=1:length(shanfacts)
   J = min(round(shanfacts(i)*spharea(TH,1)*maxJ), maxJ);
   coef = LocalIntField(B, rad, cola*pi/180, lon*pi/180, TH, Lmax, J, rplanet, rplanet+alt, rotcoord);
   B_resmod = rGvec(coef, cola_res*pi/180, lon_res*pi/180, rad_res, rplanet);
   rmse(i) = sqrt( mean( (B_resmod(:) - [Br_res;Bt_res;Bp_res]).^2 ) )
 end
 

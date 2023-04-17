function syntheticField()
% Make one Hemisphere L=30, the other hemisphere L=10. Mix them smoothly

Lmax=100

res=1;


% Northern hemisphere
Lnorth = 40;
% Build coefficient for degree Lnorth only
coefm=randn(2*Lnorth+1,1);
coefN=zeros((Lmax+1)^2,1);
coefN(Lnorth^2+1:(Lnorth+1)^2) = coefm;
% Evaluate these coefficients
[dataN,lon,lat]=plm2xyz(coef2lmcosi(coefN),res);



% Southern hemisphere
Lsouth = 10;
% Build coefficient for degree Lnorth only
coefm=randn(2*Lsouth+1,1);
coefS=zeros((Lmax+1)^2,1);
coefS(Lsouth^2+1:(Lsouth+1)^2) = coefm;
% Evaluate these coefficients
[dataS,lon,lat]=plm2xyz(coef2lmcosi(coefS),res);


% Then multiply it with a tapering functions
Lmix=1;
[G,V] = glmalpha(90,Lmix);
[Vsrt,isrt]=sort(V,'descend');
G=G(:,isrt);

taperNorth = plm2xyz(coef2lmcosi(G(:,1),1),res);
dataNorth=dataN.*taperNorth;

taperSouth = plm2xyz(coef2lmcosi(G(:,end),1),res);
dataSouth=dataS.*taperSouth;
data=dataNorth+dataSouth;

%%% Add a random white spectrum
%data = data + 0.2*plm2xyz(plm2rnd(Lmax,0,2),res);


%%% Add North America
LNam = 20;
coefm=randn(2*LNam+1,1);
coefNam=zeros((Lmax+1)^2,1);
coefNam(LNam^2+1:(LNam+1)^2) = coefm;

LNam = 30;
coefm=randn(2*LNam+1,1);
coefNam(LNam^2+1:(LNam+1)^2) = coefm;

% Evaluate these coefficients
[dataNam,lon,lat]=plm2xyz(coef2lmcosi(coefNam),res);

% Make a taper for North America
LmixNam=2;
[G,V] = glmalpha('namerica',LmixNam);
[Vsrt,isrt]=sort(V,'descend');
G=G(:,isrt);
taperNam = plm2xyz(coef2lmcosi(G(:,1),1),res);

data = data + dataNam.*taperNam;



plotplm(data,lon*pi/180,lat*pi/180)
kelicol(1)
colorbar

%save(sprintf('TwoFaceNam_Lmax%d.mat',Lmax),'data','lon','lat','Lmax','Lnorth','Lsouth');

save('Synthetic.mat','data','lon','lat','Lmax','Lnorth','Lsouth');

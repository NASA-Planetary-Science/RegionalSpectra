function FigSynthetic(expo)

load('Synthetic.mat')


dom='namerica';

regnorm = spharea(dom)*sqrt(4*pi);

%data = data+randn(size(data))*40;

%%%% calculate global power spectrum
    
specAll = plm2spec(xyz2plm(data,Lmax));
ls = 0:Lmax; 
        
figure(1); clf;
h(1) = plot(ls,specAll);
leg{1} = 'global spec';    


   
%%% Boxcar Spectrum
XY = eval(dom);
[LON,LAT]=meshgrid(lon,lat);
% Just set all locations outside of North America to zero
in = inpolygon(LON(:),LAT(:),XY(:,1),XY(:,2));
dataBOX = data;
dataBOX(~in)=0;

specBOX = plm2spec(xyz2plm(dataBOX,Lmax));

figure(1);
hold on
h(1)=plot(ls, specBOX/regnorm);%/spharea(dom));
hold off
leg{2} = 'boxcar spectrum';

%%%% Calculate regional power spectrum
%%% For North America
%Ltap = 4; % Leads to one well-concentrated Slepian function
%Ltap = 6; % Leads to two well-concentrated Slepian functions
%Ltap = 8; % Leads to three well-concentrated Slepian functions
%Ltap = 9; % Leads to four well-concentrated Slepian functions
Ltap = 4;

lmcs = xyz2plm(data,Lmax);

specNAM = localspectrum(lmcs,Ltap,dom); %/spharea(dom);

figure(1);
hold on
h(3) = plot(ls, specNAM/regnorm);
hold off
leg{3} = 'localized spec';


% %%% Localspectrum from data
% lonNAM = LON(in);
% latNAM = LAT(in);
% dataNAM = data(:);
% dataNAM = dataNAM(in);
% % scatter(lonNAM,latNAM,[],dataNAM)
% 
% shanfact = 1;
% Jcof = round(shanfact*spharea(dom)*(Lmax+1)^2);
% specNAMdata = localspectrumData(dataNAM,lonNAM,latNAM,Lmax,Ltap,dom,Jcof,[],[],[],0,0);
% 
% figure(1);
% hold on
% h(4) = plot(ls, specNAMdata/(4*pi)/regnorm);
% hold off
% leg{4} = 'Local data spec';
% 
% 



% Finalize figure

legend(leg)
%set(gca, 'YScale', 'log')
%ylim([1e-3,1e0])

if expo
    % Export everything
    
    % Lines for line plot
    mkdir('GMTdata')
    dlmwrite(fullfile('GMTdata','GlobSpec.txt'),[ls(:),specAll(:)],'delimiter','\t')
    dlmwrite(fullfile('GMTdata','BoxSpec.txt'),[ls(:),specBOX(:)/regnorm],'delimiter','\t')
    dlmwrite(fullfile('GMTdata','LocSpec.txt'),[ls(:),specNAM(:)/regnorm],'delimiter','\t')
    
    % fields for Spatial plotting
    [G,V]=glmalpha('namerica',Ltap);
    dataTAP1 = -data.*plm2xyz(coef2lmcosi(G(:,1),1),1)*sqrt(regnorm);
    dataTAP2 = -data.*plm2xyz(coef2lmcosi(G(:,2),1),1)*sqrt(regnorm);
    dataTAP3 = -data.*plm2xyz(coef2lmcosi(G(:,3),1),1)*sqrt(regnorm);
    dataTAP4 = -data.*plm2xyz(coef2lmcosi(G(:,4),1),1)*sqrt(regnorm);
    % Write coefficients
    dlmwrite(fullfile('GMTdata','SynthMultispecWeights.txt'),V(:))
    
    %%% For GMT 6.0.0 use this
    %grdwrite2p(lon,lat,data,fullfile('GMTdata','syntheticGlob.grd'))
    %grdwrite2p(lon,lat,dataBOX,fullfile('GMTdata','syntheticBox.grd'))
    %grdwrite2p(lon,lat,dataTAP,fullfile('GMTdata','syntheticTap.grd'))
    
    %%% For GMT 6.1.0 use this
    grdwrite2p(lon,flipud(lat(:)),flipud(data),fullfile('GMTdata','syntheticGlob.grd'))
    grdwrite2p(lon,flipud(lat(:)),flipud(dataBOX),fullfile('GMTdata','syntheticBox.grd'))
    grdwrite2p(lon,flipud(lat(:)),flipud(dataTAP1),fullfile('GMTdata','syntheticTap1.grd'))
    grdwrite2p(lon,flipud(lat(:)),flipud(dataTAP2),fullfile('GMTdata','syntheticTap2.grd'))
    grdwrite2p(lon,flipud(lat(:)),flipud(dataTAP3),fullfile('GMTdata','syntheticTap3.grd'))
    grdwrite2p(lon,flipud(lat(:)),flipud(dataTAP4),fullfile('GMTdata','syntheticTap4.grd'))
    
end
    
    


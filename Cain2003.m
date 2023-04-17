function coef=Cain2003()

load('Cain90.mat'); 
lmcosi = Cain90;
coef = lmcosi2coef(lmcosi,0);

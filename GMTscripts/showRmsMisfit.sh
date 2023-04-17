# INPUT:
# 1   name
# like rmsfit_manysynth_MarsNew_noise10pc_alt

# ./showRmsMisfit.sh rmsfit_manysynth_MarsNew_noise10pc_alt
#./showRmsMisfit.sh rmsfit_manysynth_MarsNew_surface_noise10p_alt

gmt begin ../GMTfigs/${1} pdf

gmt set MAP_POLAR_CAP none

gmt set FONT 15p

#awk 'FNR == 5 {print $3}'

# minA=$(awk -F',' 'FNR == 1 {print $1; exit}'  ../GMTdata/examples/${name}.txt)
# maxA=$(awk -F',' 'END {print $1; exit}'  ../GMTdata/examples/${name}.txt)
# minr=$(awk -F',' 'FNR == 1 {print $2; exit}'  ../GMTdata/examples/${name}.txt)
# maxr=$(awk -F',' 'END {print $2; exit}'  ../GMTdata/examples/${name}.txt)
# minRMSE=$(awk -F',' 'FNR == 1 {print $3; exit}'  ../GMTdata/examples/${name}.txt)
# maxRMSE=$(awk -F',' 'END {print $3; exit}'  ../GMTdata/examples/${name}.txt)


file=../GMTdata/examples/${1}.grd


minA=$(gmt grdinfo ${file} -Cn -o0)
maxA=$(gmt grdinfo ${file} -Cn -o1)
minr=$(gmt grdinfo ${file} -Cn -o2)
maxr=$(gmt grdinfo ${file} -Cn -o3)
minrms=$(gmt grdinfo ${file} -Cn -o4)
# Also need to get the minumum to plot it
Acoord=$(gmt grdinfo ${file} -M -Cn -o10)
rcoord=$(gmt grdinfo ${file} -M -Cn -o11)


#gmt grd2cpt ${file} -Cbamako -Z -L${minrms}/0.7
gmt makecpt -CbatlowW -T0.2/1/0.01 -Z
gmt grdimage ${file} -JX10c/10c -R${minA}/${maxA}/${minr}/${maxr} -BNesW -Bya10 -Bxa0.02 -By+l"source radius @[r_x@[ [km]" -Bx+l"spectral factor @%6%A@%% [nT@+2@+]"
#### Also show min
gmt plot -Sc0.3c -W3p,white <<EOF
${Acoord} ${rcoord} ${minrms}
EOF

gmt colorbar -DJBC+w10c+o0c/0.4c+ef -B+l"rms misfit [log(nT@+2@+)]"


gmt end show

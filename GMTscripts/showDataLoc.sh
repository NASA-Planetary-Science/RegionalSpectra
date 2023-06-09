gmt begin ../GMTfigs/MarsDataLoc

gmt set MAP_POLAR_CAP none

# prep topo (comment out once done)
topo=../GMTdata/MarsTopo16ppd.grd
topolow=../GMTdata/MarsTopoLow.grd
topograd=../GMTdata/MarsTopo16ppd_gradient.grd

#gmt grdsample ${topo} -G${topolow} -I0.15
#gmt grdgradient $topolow -G$topograd -A270/0/90 -Ne0.5


ds=0.04c

colrng=-300/300/1
### Full data panel
dotsize=${ds}
# Plot Mars topo black and white for the area and a bit outside
gmt makecpt -Cgray -T-1.5/1/0.1 -Z
gmt grdimage $topograd -C -Ra -JG200/-69/25/7c
# Plot data dots on top
gmt makecpt -Cvik -T${colrng} -Z 
gmt plot ../GMTdata/synth_MarsNew_noise10pc_gmtloc.txt -Sc${dotsize} -Rg -C -Bxa30g30 -Bya10g10 -BNSEW
gmt text -R0/1/0/1 -Jx7c --FONT=20 <<EOF
0.05 0.95 a
EOF
gmt text -R0/1/0/1 -Jx7c --FONT=13 <<EOF
0.1 0.05 100%
EOF

### Plot subsample 2
dotsize=${ds}
gmt makecpt -Cgray -T-1.5/1/0.1 -Z
gmt grdimage $topograd -C -Ra -JG200/-69/25/7c -X7.5c
gmt makecpt -Cvik -T${colrng} -Z 
gmt plot ../GMTdata/synth_MarsNew_noise10pc_sub30_gmtloc.txt -Sc${dotsize} -Rg -C -Bxa30g30 -Bya10g10 -BNSEW -W0.01p,black
gmt text -R0/1/0/1 -Jx7c --FONT=20 <<EOF
0.05 0.95 b
EOF
gmt text -R0/1/0/1 -Jx7c --FONT=13 <<EOF
0.1 0.05 30%
EOF

### Plot subsample
dotsize=${ds}
gmt makecpt -Cgray -T-1.5/1/0.1 -Z
gmt grdimage $topograd -C -Ra -JG200/-69/25/7c -X7.5c
gmt makecpt -Cvik -T${colrng} -Z 
gmt plot ../GMTdata/synth_MarsNew_noise10pc_sub10_gmtloc.txt -Sc${dotsize} -Rg -C -Bxa30g30 -Bya10g10 -BNSEW -W0.01p,black
gmt text -R0/1/0/1 -Jx7c --FONT=20 <<EOF
0.05 0.95 c
EOF
gmt text -R0/1/0/1 -Jx7c --FONT=13 <<EOF
0.1 0.05 10%
EOF




### Colorbar
gmt colorbar -X-14c -Y-1c -Dx0c/0c+w20c/0.3c+h+e --FONT=13 -B100+l"radial component at data altitude [nT]"





### Plot selection for J
gmt set FONT 13

minval=116 #4.23
maxval=120

gmt basemap -Y-6c -X0.5c -JX8.5c/4c -R720/925/${minval}/${maxval} -Bnews
for i in {1..100}
do
    gmt plot ../GMTdata/examples/manyrmse_MarsNew_surface_noise10p_alt/rmse${i}.txt -Wgray
done
gmt plot ../GMTdata/examples/manyrmse_MarsNew_surface_noise10p_alt/mean_rmse.txt -Wthick,black -Bxa25 -Bya1 -BneSW -Bx+l"number @[J@[ of Slepian functions" -By+l"rmse [nT]"


# Draw min. It is at J=824, rmse=117.63
gmt plot -Sc0.2c -Wthick <<EOF
824 117.63
EOF
gmt plot -BnSeW  -Wblack <<EOF
824 ${maxval}
824 117.63
EOF
gmt text -N  --FONT=13 <<EOF
824 120.4 824
EOF
# A tick mark
gmt plot -N -Sy5p <<EOF
824 ${maxval} 
EOF
gmt text -R0/1/0/1 -Jx9c/4c --FONT=20 <<EOF
0.04 0.9 d
EOF
gmt text -R0/1/0/1 -Jx9c/4c --FONT=13 <<EOF
0.33 0.1 surface, 30% subselection
EOF





minval=4.14 #4.23
maxval=4.35


gmt basemap -X12c -JX8.3c/4c -R165/385/${minval}/${maxval} -Bnesw #-X-13c -Y-4.7c
for i in {1..100}
do
    gmt plot ../GMTdata/examples/manyrmse_MarsNew_noise10pc_alt2/rmse${i}.txt -Wgray
done
gmt plot ../GMTdata/examples/manyrmse_MarsNew_noise10pc_alt2/mean_rmse.txt -Wthick,black -Bxa25 -Bya0.05 -BneSW -Bx+l"number @[J@[ of Slepian functions" -By+l"rmse [nT]"

# Draw min. It is at J=234, rmse=4.2422734558
gmt plot -Sc0.2c -Wthick <<EOF
234 4.2422734558
EOF
gmt plot -BnSeW  -Wblack <<EOF
234 ${maxval}
234 4.2422734558
EOF
gmt text -N  --FONT=13 <<EOF
234 4.372 234
EOF
# A tick mark
gmt plot -N -Sy7p <<EOF 
234 ${maxval} 
EOF
gmt text -R0/1/0/1 -Jx9c/4c --FONT=20 <<EOF
0.04 0.9 e
EOF
gmt text -R0/1/0/1 -Jx9c/4c --FONT=13 <<EOF
0.43 0.1 300 km altitude, 10% subselection
EOF



gmt end show

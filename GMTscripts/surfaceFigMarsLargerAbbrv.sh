gmt begin ../GMTfigs/MarsLargerResultSurfaceAbbrv_noise10p pdf


str=_surface_noise10p_alt
#str=_surface_noise2p_alt
str2=_surface_noise10p_sub30

# str=_newsampling_surface_2p_moreSlep_alt
# str2=_newsampling_surface_2p_moreSlep_sub30

# str=_newsampling_surface_2p_alt
# str2=_newsampling_surface_2p_sub30

THshow=34
regionpen=2.5p,black,-
regionpen2=2.5p,gray,-

gmt set MAP_POLAR_CAP none
gmt set FONT 12p


#### Results


R=0/359.8/-89.99/-35.19
topo=../GMTdata/MarsTopo16ppd.grd
topomod=../GMTdata/MarsTopoMod.grd
topogradmod=../GMTdata/MarsTopo16ppd_gradient_model.grd

# Mean
model=../GMTdata/synthMarsNewLarger${str2}_mean.grd
modhi=../GMTdata/synthMarsNewLarger${str2}_mean_hi.grd
gmt grdsample ${topo} -G${topomod} -R${R} -I0.1 -T
gmt grdsample ${model} -G${modhi} -R${R} -I0.1
gmt grdgradient ${topomod} -G${topogradmod}  -R${R} -A270/0/90 -Ne0.5
#gmt grd2cpt ${model} -Cvik -Z -Sh -H > colmodsurf.cpt

gmt grdimage -Ccolmodsurf.cpt ${modhi} -I${topogradmod}  -R${R} -JG200/-69/${THshow}/7c -Bxa30g30 -Bya10g10 -BNSEW
gmt plot ../GMTdata/MarsRegion.txt -W${regionpen}
gmt colorbar -Ccolmodsurf.cpt -DJCL+o0.5c/0c --FORMAT_FLOAT_MAP=%.0f -S+x"mean model @[B_r@[ [nT]"
gmt text -R0/1/0/1 -JX7c/7c --FONT=20 <<EOF
0.05 0.92 a
EOF


# Difference

# Prepare model
model=../GMTdata/Lang_Br.grd
modhi=../GMTdata/Lang_Br_hi.grd
gmt grdsample ${topo} -G${topomod} -R${R} -I0.1 -T
gmt grdsample ${model} -G${modhi} -R${R} -I0.1

mod1=../GMTdata/synthMarsNewLarger${str2}_mean_hi.grd
mod2=../GMTdata/Lang_Br_hi.grd
CMdiff=../GMTdata/Lang_minus_synthMarsNewLarger${str2}_mean_hi.grd
gmt grdmath ${mod2} ${mod1} SUB = ${CMdiff}
#gmt grd2cpt ${CMdiff} -Cvik -Z -Sh
gmt grdimage -Ccolmodsurf.cpt ${CMdiff} -I${topogradmod}  -R${R} -JG200/-69/${THshow}/7c -Bxa30g30 -Bya10g10 -BNSEW -X7.5c
gmt plot ../GMTdata/MarsRegion.txt -W${regionpen}
gmt colorbar -DJCR+o0.5c/0c --FORMAT_FLOAT_MAP=%.0f -S+x"L134 minus mean model @[B_r@[ [nT]"
gmt text -R0/1/0/1 -JX7c/7c --FONT=20 <<EOF
0.05 0.92 b
EOF


####### Spectra

name=manySpecs_MarsNewLarger${str}
#rng=3311/3323
rng=3302/3303.8
lrngmax=126


# Plot many spec
shadecol=230
linecol=150/150/150
linecol2=100/100/100
gmt set FONT 13
gmt basemap -X-7.5c -Y-4.5c -JX13c/4cl -R0/134/1e-1/1e4 -BneSW -Bxa10 -By10f1p -Bx+l"spherical harmonic degree @[l@[" -By+l"power @[R_l@[ [nT@[^2@[]"
# Shade areas of unused degrees
gmt plot -G${shadecol} <<EOF
0 1e4
0 1e-1
9 1e-1
9 1e4
0 1e4
EOF
gmt plot -G${shadecol} -Bnsew <<EOF
${lrngmax} 1e4
${lrngmax} 1e-1
135 1e-1
135 1e4
80 1e4
EOF
for i in {1..100}
do
    gmt plot ../GMTdata/examples/${name}/spec${i}.txt -W0.1p,${linecol}
done
# Also show localized spec
gmt plot ../GMTdata/examples/localspec_MarsNewLarger.txt -W1p,black,1_2
# also average fit spec
gmt plot ../GMTdata/examples/avgfit_${name}.txt -W0.8p,${linecol2},-
# Label
gmt text -R0/1/0/1 -JX13c/4c -N --FONT=20 <<EOF
0.03 0.9 c
EOF


# Second panel with source radii
lnrng=1p,black
lneach=0.7p,${linecol}

mn=$(gmt math ../GMTdata/examples/rs_${name}.txt -Sl -o1 MEAN = )
std=$(gmt math ../GMTdata/examples/rs_${name}.txt -Sl -o1 STD  = )
bot=$(echo ${mn}-${std} | bc)
top=$(echo ${mn}+${std} | bc)
gmt plot ../GMTdata/examples/rs_${name}.txt -X14c -R-1/1/${rng} -JX0.5c/4c -S-0.2c -BnsEw -Bya0.5 -W${lneach} -By+l"source radius @[r_x@[ [km]"
# Plot range of results
gmt plot -Sc0.3c -W${lnrng} <<EOF
0 ${mn}
EOF
gmt plot -W${lnrng} -S-0.4c <<EOF
0 ${bot}
0 ${top}
EOF
gmt plot -W${lnrng} <<EOF
0 ${bot}
0 ${top}
EOF
# Plot localized source depth
gmt plot -S-0.5c -W2p,black,1_2 <<EOF
0 3302.3
EOF
# Label
gmt text -R0/1/0/1 -JX0.5c/4c -N --FONT=20 <<EOF
-0.7 0.9 d
EOF







gmt end show

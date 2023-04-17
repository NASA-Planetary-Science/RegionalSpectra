gmt begin ../GMTfigs/CrustExample pdf

gmt set MAP_POLAR_CAP none
gmt set FONT 12p

sf=1.25
str=_noise5pc

showTH=30

# Show the data
gmt makecpt -Cvik -T-320/320/80 -Z
gmt plot -C ../GMTdata/examples/plotting_Mars_fulldata${str}.txt -R150/250/-90/-30 -JG200/-69/${showTH}/6c -Sc0.04c -Bag30
gmt colorbar -C -DJCL+o0.3c/0c -B+l"radial component [nT]"


# Show the inverted model
gmt makecpt -Cvik -T-6000/6000/2000 -Z 
gmt grdimage -C ../GMTdata/examples/plotting_Mars_model${str}_cmp1.nc -R150/250/-90/-30 -JG200/-69/${showTH}/6c -Bag30 -X6.5c
gmt colorbar -C -DJCR+o0.3c/0c -B+l"radial component [nT]"


# Show the power spectra

### Plot each for a range of subsample plotting
gmt plot ../GMTdata/examples/spec_Mars_sf${sf}_nr1${str}.txt -Wgray -JX10c/3cl -R-0.1/90.1/1e0/1e4  -X-6.5c -Y-3.5c
for int in {2..100}
do
gmt plot ../GMTdata/examples/spec_Mars_sf${sf}_nr${int}${str}.txt -Wgray 
done


### Plot the full data one
gmt plot ../GMTdata/examples/spec_Mars_sf${sf}_alldata${str}.txt -Wblack,. 
#### I don't know if this is really the one with no


### Plot the local spectrum from the global coefficients
gmt plot ../GMTdata/examples/localspec_Mars.txt -Wblack,-- -Bya1p -Bxa10 


### Plot theoretical spectrum



# Source radii
gmt plot -X10.5c ../GMTdata/examples/radii_Mars_sf${sf}${str}.txt -S-0.3c -JX1c/3c -R-0.5/0.5/3320/3360 -Wgray -BnsEw


gmt end show

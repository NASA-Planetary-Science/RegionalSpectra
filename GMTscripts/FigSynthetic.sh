# Define the projection
#proj=W270
proj=H270

gmt begin ../GMTfigs/FigSynthetic pdf

#### Set fontsize etc
gmt set FONT_ANNOT_PRIMARY 12p
gmt set MAP_FRAME_PEN thin,black
#gmt set FONT_ANNOT_SECONDARY 12p

#### Set up common color scheme
gmt makecpt -Cvik -T-60/60/30 -Z -D

#### Set up subplots
# -A means autonumbering
# -M sets the margins
gmt set FONT_TAG 15p
gmt subplot begin 2x2  -F15c/8c -M-0.12c -Aa #-M-0.5c

### Global field
gmt subplot set 0,0
gmt grdimage ../GMTdata/syntheticGlob.grd -Rg -J${proj}/? -C -Ba0 -Bew
gmt coast -W0.6p,black

### Boxcar field
gmt subplot set 0,1
gmt grdimage ../GMTdata/syntheticBox.grd -Rg -J${proj}/? -C -Ba0 -Bew
gmt coast -W0.6p,black

### Tapered field
gmt subplot set 1,0
gmt grdimage ../GMTdata/syntheticTap.grd -Rg -J${proj}/? -C -Ba0 -Bew
gmt coast -W0.6p,black

### Spectra
gmt subplot set 1,1 -Cs0.9c -Ce1c

symbsize=0.1c
linewid=0.02c
fcol=50/50/50
bcol=120/120/120
lcol=0/0/0

gmt basemap -R0/65/0.0/0.4 -JX? -Bxa10+l"spherical-harmonic degree @[l@[" -Bya0.1+l"power spectrum" -BnESw --FONT_ANNOT_PRIMARY=10p --FONT_LABEL=10p --MAP_LABEL_OFFSET=3p --MAP_ANNOT_OFFSET_PRIMARY=2p --MAP_TICK_LENGTH_PRIMARY=3p
## Global spec
gmt plot ../GMTdata/GlobSpec.txt -W${linewid},${fcol} -l"global"
## Boxcar spec
gmt plot ../GMTdata/BoxSpec.txt -W${linewid},${bcol},1_0.5_1_0.5:1 -l"boxcar"
## Local spec
gmt psxy ../GMTdata/LocSpec.txt -W${linewid},${lcol},5_1:1 -l"multitaper"

gmt legend --FONT_ANNOT_PRIMARY=9p -DjTR  #-F


gmt subplot end

gmt end show



#### Provide the second indices
ind2Low=2
ind2High=60
ind2Alt=60



gmt begin ../GMTfigs/FigSlepian

#### Set fontsize etc
gmt set FONT_ANNOT_PRIMARY 12p
gmt set MAP_FRAME_PEN thin,black

#### Set up subplots
# -A means autonumbering
# -M sets the margins
gmt set FONT_TAG 14p #15p
gmt subplot begin 3x2 -Fs4c/4c -JG15/5/4c -Rg -Aa -SC -SR
#-M-0.5c

### Low-degree classical
gmt subplot set 0,0
gmt grd2cpt ../GMTdata/SlepLow1.grd  -Cvik -D -Sh -Z
gmt grdimage ../GMTdata/SlepLow1.grd -C -Ba0 
gmt coast -W0.6p,black
gmt legend -DJBL+w1c --FONT_ANNOT=11p <<EOF
P 0.4 0.75 - - - - - c
T @%2%L@%%=4
EOF
gmt legend -DJBL+w1c --FONT_ANNOT=11p <<EOF
P 1.65 0.75 - - - - - c
T @%2%j@%%=1
EOF
gmt legend -DJCL+w0.9c <<EOF
P - 0 - 90 - - - c
T taper
EOF
# gmt legend -DJTC+w2c <<EOF
# P - 0.25 - - - - - -
# T largest @~l@~
# EOF

gmt subplot set 0,1 
gmt grd2cpt ../GMTdata/SlepLow${ind2Low}.grd -Cvik -D -Sh -Z
gmt grdimage ../GMTdata/SlepLow${ind2Low}.grd -C -Ba0
gmt coast -W0.6p,black
gmt legend -DJBL+w1c --FONT_ANNOT=11p <<EOF
P 0.4 0.75 - - - - - c
T @%2%L@%%=4
EOF
gmt legend -DJBL+w1c --FONT_ANNOT=11p <<EOF
P 1.65 0.75 - - - - - c
T @%2%j@%%=2
EOF
# gmt legend -DJTC+w2c <<EOF
# P - 0.25 - - - - - -
# T smaller @~l@~
# EOF

### High-degree classical
gmt subplot set 1,0 
gmt grd2cpt ../GMTdata/SlepHigh1.grd  -Cvik -D -Sh -Z
gmt grdimage ../GMTdata/SlepHigh1.grd -C -Ba0
gmt coast -W0.6p,black
gmt legend -DJBL+w1.2c --FONT_ANNOT=11p <<EOF
P 0.4 0.75 - - - - - c
T @%2%L@%%=40
EOF
gmt legend -DJBL+w1c --FONT_ANNOT=11p <<EOF
P 1.65 0.75 - - - - - c
T @%2%j@%%=1
EOF
gmt legend -DJCL+w0.9c <<EOF
P - 0 - 90 - - - c
T taper
EOF

gmt subplot set 1,1 
gmt grd2cpt ../GMTdata/SlepHigh${ind2High}.grd  -Cvik -D -Sh -Z
gmt grdimage ../GMTdata/SlepHigh${ind2High}.grd -C -Ba0
gmt coast -W0.6p,black
gmt legend -DJBL+w1.2c --FONT_ANNOT=11p <<EOF
P 0.4 0.75 - - - - - c
T @%2%L@%%=40
EOF
gmt legend -DJBL+w1.2c --FONT_ANNOT=11p <<EOF
P 1.7 0.75 - - - - - c
T @%2%j@%%=60
EOF


### High-degree altitude
gmt subplot set 2,0 
gmt grd2cpt ../GMTdata/SlepAlt1.grd -Cvik -D -Sh -Z
gmt grdimage ../GMTdata/SlepAlt1.grd -C -Ba0
gmt coast -W0.6p,black
gmt legend -DJBL+w1.2c --FONT_ANNOT=11p <<EOF
P 0.4 0.75 - - - - - c
T @%2%L@%%=40
EOF
gmt legend -DJBL+w1c --FONT_ANNOT=11p <<EOF
P 1.65 0.75 - - - - - c
T @%2%j@%%=1
EOF
gmt legend -DJCL+w0.9c <<EOF
P - 0 - 90 - - - c
T altitude-cognizant
EOF

gmt subplot set 2,1 
gmt grd2cpt ../GMTdata/SlepAlt${ind2Alt}.grd -Cvik -D -Sh -Z
gmt grdimage ../GMTdata/SlepAlt${ind2Alt}.grd -C -Ba0
gmt coast -W0.6p,black
gmt legend -DJBL+w1.2c --FONT_ANNOT=11p <<EOF
P 0.4 0.75 - - - - - c
T @%2%L@%%=40
EOF
gmt legend -DJBL+w1.2c --FONT_ANNOT=11p <<EOF
P 1.7 0.75 - - - - - c
T @%2%j@%%=60
EOF

gmt subplot end

gmt end show

gmt begin ../GMTfigs/FigExpect pdf

#### Set fontsize etc
#gmt set FONT_ANNOT_PRIMARY 12p
gmt set MAP_FRAME_PEN thin,black
gmt set FONT_TAG 15p
gmt set FONT_ANNOT_PRIMARY 10p
gmt set FONT_LABEL 10p
gmt set MAP_LABEL_OFFSET 3p
gmt set MAP_ANNOT_OFFSET_PRIMARY 2p
gmt set MAP_TICK_LENGTH_PRIMARY 3p 

Lmax=13

symbsize=0.1c
linewid=0.02c
#fcol=50/50/50
fcol=150/150/150
bcol=90/90/90
lcol=0/0/0

gmt subplot begin 2x2 -Fs10c/2.5c -SC -M0.20c/0.5c


# gmt subplot set 0,0

# gmt basemap -R-0.2/13.2/1e1/1e10 -JX?/?l  -Bxa1+l"spherical-harmonic degree @%2%@L@%%" -Bya-2p+l"power spectrum [nT@+2@+]" -BnesW
# #--FONT_ANNOT_PRIMARY=10p --FONT_LABEL=10p --MAP_LABEL_OFFSET=3p --MAP_ANNOT_OFFSET_PRIMARY=2p --MAP_TICK_LENGTH_PRIMARY=3p
# gmt text --FONT_ANNOT_PRIMARY=13p <<EOF
# 0.2 5e8 a
# EOF

# TH=90
# # Expected spec
# gmt plot ../GMTdata/expectedSpec/expected_TH${TH}_rot30_Lmax${Lmax}_Ltap3.txt -W${linewid},${lcol} -l"expected"

# # Local spec
# gmt plot ../GMTdata/expectedSpec/local_TH${TH}_rot30_Lmax${Lmax}_Ltap3.txt -Sc${symbsize} -W${linewid},${lcol} -l"local"
# gmt legend -DjBL   #--FONT_ANNOT_PRIMARY=7.5p  # -F
# gmt subplot set 0,1 -Cw-3.5c  -Cs1.1c # -Cs2.85c -Cw-3.9c

# # Draw cap insert
# gmt basemap  -Rg -JH180/2.5c -BNESW -Bxg90 -Byg45 --MAP_FRAME_PEN=0.5p,black
# gmt plot  ../GMTdata/expectedSpec/cap${TH}p.txt  -Rg -JH180/2.5c -Wblack -Ggray



# Original second panel, now first panel
gmt subplot set 0,0 #-Cn0.2c

# Prep plot background
gmt basemap -R-0.2/13.2/1e1/1e10 -JX?/?l  -Bxa1+l"spherical-harmonic degree @%2%@L@%%" -Bya-2p+l"power @[R_l@[ [nT@[^2@[]" -BneSW

TH=20
Lmax=13
rot=30
Ltap=3

# Local spec
gmt plot ../GMTdata/expectedSpec/local_TH${TH}_rot30_Lmax${Lmax}_Ltap${Ltap}.txt -W${linewid},${lcol} -l"local"
# Expected spec
gmt plot ../GMTdata/expectedSpec/expected_TH${TH}_rot${rot}_Lmax${Lmax}_Ltap${Ltap}.txt -W${linewid},${fcol} -l"expected"
gmt legend -DjBL # -F  --FONT_ANNOT_PRIMARY=7.5p
gmt text --FONT_ANNOT_PRIMARY=14p -R0/1/0/1 -JX?/? <<EOF
0.03 0.87 a
EOF


# Draw cap insert
gmt subplot set 0,1 -Cw-3.5c -Cs1.1c  # -Cs2.85c
#gmt basemap -Rg -JH0/2.5c -BNESW -Bxg90 -Byg45 --MAP_FRAME_PEN=0.5p,black
gmt coast -Rg -JH0/2.5c -A0/0/1 -Bnews -W0.05p,black --MAP_FRAME_PEN=0.5p,black -Bxg0 -Byg0
gmt plot ../GMTdata/expectedSpec/cap${TH}.txt -Rg -JH0/2.5c -W0.5p,black -Ggray 



# Second panel: Mars
gmt subplot set 1,0 #-Cn0.2c

# Prep plot background
gmt basemap -R-0.5/134.5/1e-2/1e5 -JX?/?l  -Bxa20+l"spherical-harmonic degree @%2%@L@%%" -Bya-2p+l"power @[R_l@[ [nT@[^2@[]" -BneSW

TH=20
Lmax=134
rot=159
Ltap=3

# Local spec
gmt plot ../GMTdata/expectedSpec/local_MarsNew_TH${TH}_rot${rot}_Lmax${Lmax}_Ltap${Ltap}.txt -W${linewid},${lcol} -l"local"
# Expected spec
gmt plot ../GMTdata/expectedSpec/expected_MarsNew_TH${TH}_rot${rot}_Lmax${Lmax}_Ltap${Ltap}.txt -W${linewid},${fcol} -l"expected"
gmt legend -DjBL # -F  --FONT_ANNOT_PRIMARY=7.5p
gmt text --FONT_ANNOT_PRIMARY=14p  -JX?/? -R0/1/0/1 <<EOF
0.03 0.87 b
EOF


# Draw cap insert
gmt subplot set 1,1 -Cw-3.5c -Cs0.15c  # -Cs2.85c
#gmt basemap -Rg -JH0/2.5c -BNESW -Bxg90 -Byg45 --MAP_FRAME_PEN=0.5p,black
gmt grdcontour ../GMTdata/MarsTopo16ppd.grd -C0, -Q1000 -Rg -JH180/2.5c -Bnews -W0.05p,black --MAP_FRAME_PEN=0.5p,black -Bxg0 -Byg0
gmt plot  ../GMTdata/MarsRegionp.txt -JH180/2.5c -W0.5p,black -Ggray 






gmt subplot end

gmt end show

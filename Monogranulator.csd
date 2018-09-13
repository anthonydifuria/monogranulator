/*
MONOGRANULATOR
by Anthony Di Furia
*/

<CsoundSynthesizer>
<CsOptions>

-o dac
-+rtmidi=null
-+rtaudio=null
-d
-+msg_color=0
--expression-opt
-M0
-m0
-i adc

</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64

;;;;SR;;;;        //strings replaced from Objective-C
;;;;KSMPS;;;;

nchnls = 2
0dbfs = 1

giLiveBuf1    ftgen     0, 0, sr*6, -2, 0
giLiveBuf2    ftgen     0, 0, sr*6, -2, 0
giphasfreq1 = 1 / (ftlen(giLiveBuf1) / sr)
giphasfreq2 = 1 / (ftlen(giLiveBuf2) / sr)

gares1 init 0
gaoutL init 0
gaoutR init 0
gaoutRevL init 0
gaoutRevR init 0
girand init 0
gidens_rand init 0
giperiodic_dens init 0
giratio_wave init 0
gkwidth init 0
gkdepth init 1
gkpeak_reset init 0
gkpeakinitL init 0
gkpeakinitR init 0
giPanMeter init 0
giamp0 init 0

;POSITION
gkvelPosition init 0


instr 3 ;INPUT LIVE

aL inch 1

kamp downsamp aL
chnset kamp , "waveform"

gagrainmono = aL

endin

instr 8
event_i "i", 9, 0, 0.05
event_i "i", 40, 6, 36000
event_i "i", 14, 6, 36000
endin

;init grain
instr 9

turnoff2 14,0,0
turnoff2 17,0,0
turnoff2 40,0,0

endin

instr 11

;amplitude original
gkamp_original chnget "in_original"

;phase
gkvel1 chnget "phase"

;duration
kdur chnget "dur"
gkdur1 = kdur/1000

kdur_rand chnget "dur_rand"
gkdur_rand = kdur_rand/1000

;env
gka_env chnget "att"
gkd_env chnget "dec"
gks_env chnget "sus"
gkr_env chnget "rel"

gkamp_Aenv chnget "amp_att"
gkamp_Denv chnget "amp_dec"
gkamp_Senv chnget "amp_sus"
gkamp_Renv chnget "amp_rel"

;dens
kdens chnget "dens"

gkdens = 1/(kdens+1)

gkdens_rand chnget "dens_rand"

gkamp_dens chnget "dens_amp"
gkfreq_dens chnget "dens_freq"

;freq
gkfreq_rand chnget "freq_rand"

;Effect
gkfond_eq chnget "fond_eq"
gkcut chnget "cut"
gkfeedback chnget "feedback"
gkp1 chnget "p1"

gkrand_harmonic chnget "rand_harmonic"

gkam_freq chnget "AM_freq"
kam_rand chnget "AM_rand"
kmin_rand chnget "min_rand_AM"
kmax_rand chnget "max_rand_AM"
krate_rand chnget "rate_rand_AM"
krand_AM randomh kmin_rand, kmax_rand, krate_rand
krand_AM portk krand_AM, 0.1

gkrand_AM = krand_AM*kam_rand
gkam_amp chnget "AM_amp"

;SPACE
gkwidth chnget "width"
gkdepth chnget "depth"
gkspreadPAN chnget "spreadPAN"
gkspreadDIST chnget "spreadDist"
gkairfilter chnget "air"

;VUMETER
gkscale chnget "scale"
gkresetpeak chnget "resetpeak"
gkmeter_value chnget "vumeter_value"

endin


instr 13;INITIALITATION GRANULATION 1

awritpnt    phasor        giphasfreq1

ptablew        gagrainmono, awritpnt, giLiveBuf1, 1, 0, 1

gagrainmono = 0

endin


instr 14

clock:
gidens_rand = rnd((i(gkdens)-0.01)*i(gkdens_rand))

kdens_sum = (1/(i(gkdens)-gidens_rand))
chnset kdens_sum , "dens_sum"

timout 0, (i(gkdens)-gidens_rand), time
reinit clock

time:
girand = rnd(i(gkdur_rand))

event_i "i", 17, 0, i(gkdur1)+girand

;freq
gkfreq_oct chnget "freq_oct"

endin


instr 16

kamp_FM chnget "amp_FM"
kfreq_FM chnget "freq_FM"

kfFM oscili kamp_FM, kfreq_FM, 1

gkfFM = abs(kfFM)

endin


instr 17

;dur
idur_sum = (i(gkdur1)+girand)

;env
iadsr = idur_sum/4

iattack = 1*iadsr*i(gka_env)
idecay = 1*iadsr*i(gkd_env)
isustain = 1*iadsr*i(gks_env)
irelease = 1*iadsr*i(gkr_env)
iampatt = i(gkamp_Aenv)
iampdec = i(gkamp_Denv)
iampsus = i(gkamp_Senv)
iamprel = i(gkamp_Renv)

kdur_sum = iattack+idecay+isustain+irelease
chnset kdur_sum , "dur_sum"

;freq
irand_freq = rnd(3)*i(gkfreq_rand)

kratio chnget "ratio"
kres_ratio chnget "res_ratio"

irand_freq_ratio = int(rnd(i(kres_ratio)))
irand_ratio = i(kratio)

if(irand_freq_ratio = 0)then

ifreq_r = 1*1

elseif(irand_freq_ratio = 1)then

ifreq_r = irand_ratio

elseif(irand_freq_ratio = 2)then

ifreq_r = irand_ratio*irand_ratio

elseif(irand_freq_ratio = 3)then

ifreq_r = irand_ratio*irand_ratio*irand_ratio

elseif(irand_freq_ratio = 4)then

ifreq_r = irand_ratio*irand_ratio*irand_ratio*irand_ratio

elseif(irand_freq_ratio = 5)then

ifreq_r = irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio

elseif(irand_freq_ratio = 6)then

ifreq_r = irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio

elseif(irand_freq_ratio = 7)then

ifreq_r = irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio

elseif(irand_freq_ratio = 8)then

ifreq_r = irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio

elseif(irand_freq_ratio = 9)then

ifreq_r = irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio*irand_ratio

endif


;generation
aenv linseg 0, iattack, iampatt, idecay, iampdec, isustain, iampsus, irelease, iamprel

aoriginal osciliktp giphasfreq1, giLiveBuf1, gkvel1

awritpnt    phasor        giphasfreq2

ptablew        aoriginal, awritpnt, giLiveBuf2, 1, 0, 1

ares osciliktp (giphasfreq2*(i(gkfreq_oct)+irand_freq)*ifreq_r)+gkfFM, giLiveBuf2, 0

;Amplitude Original
ares_original = ares*gkamp_original

;Amplitude modulation
aAM oscili gkam_amp,gkam_freq+gkrand_AM,1
aAM_out = ares*aAM

kfreqAMvalue = gkam_freq+gkrand_AM
chnset kfreqAMvalue , "am_freq_randomicvalue"

;Waveguide
irand_harm = int(rnd(i(gkrand_harmonic)))
ipar1 = irand_harm+1

ares1 wguide1 ares, gkfond_eq*ipar1, gkcut, gkfeedback
ares_guide = ares1*gkp1

aspatial = ares_original+aAM_out+ares_guide

;SPATIAL
istereo = (rnd(2)-1)*i(gkspreadPAN)

ipanMeter0 = i(gkwidth)+istereo


if(ipanMeter0 > 1) then

ipanMeter  = 1

elseif(ipanMeter0 < 0) then

ipanMeter  = 0

else

ipanMeter  = ipanMeter0

endif

ares_pan_sum = aspatial*aenv


idepth = sqrt(i(gkdepth))
ispreadDIST = sqrt(i(gkspreadDIST))

idist = (rnd(1)*(idepth))*(ispreadDIST)
iamp0 = (idepth)-idist

iamp = abs(iamp0-1)

giamp0 = iamp0
giPanMeter = ipanMeter

aoutL, aoutR pan2 ares_pan_sum*iamp, ipanMeter
aoutRevL, aoutRevR pan2 ares_pan_sum, ipanMeter



goto sumout

sumout:

gaoutRevL = gaoutRevL + aoutRevL
gaoutRevR = gaoutRevR + aoutRevR

gaoutL = gaoutL + aoutL
gaoutR = gaoutR + aoutR

endin


instr 40; CONTROLLO USCITE

;OUT
kroom chnget "room"
kdamp chnget "damp"
kampRev chnget "revAmp"

;REV
arevL, arevR freeverb gaoutRevL*kampRev, gaoutRevR*kampRev, kroom, kdamp

;METER
koutput chnget "output"
asigL = (gaoutL+arevL)*koutput
asigR = (gaoutR+arevR)*koutput

krmsL rms asigL
krmsR rms asigR

kpeak0L = gkpeakinitL
kpeak0R = gkpeakinitR

krmsL_meter = krmsL
krmsR_meter = krmsR

kpeakL_meter = kpeak0L
kpeakR_meter = kpeak0R

if(gkscale = 0) then

krmsL = dbamp(krmsL)
krmsR = dbamp(krmsR)

kpeakL = dbamp(kpeak0L)
kpeakR = dbamp(kpeak0R)

elseif(gkscale = 1)then

krmsL = krmsL*100
krmsR = krmsR*100

kpeakL = kpeak0L*100
kpeakR = kpeak0R*100

endif

chnset krmsL, "meterL_rmslabel"
chnset krmsR, "meterR_rmslabel"
chnset kpeakL, "meterL_peaklabel"
chnset kpeakR, "meterR_peaklabel"

chnset krmsL_meter , "meterL"
chnset krmsR_meter , "meterR"

chnset kpeakL_meter , "meterL_peak"
chnset kpeakR_meter , "meterR_peak"

gaout_meterL = asigL
gaout_meterR = asigR

outs asigL,asigR

gaoutL = 0
gaoutR = 0
gaoutRevL = 0
gaoutRevR = 0
gares1 = 0

endin


;controlling vumeter
instr 100

;meter spatial
kpanMeter = giPanMeter
chnset kpanMeter , "panMeter"
kdistmeter = giamp0
chnset kdistmeter , "distMeter"

gkpeakinitL peak gaout_meterL
gkpeakinitR peak gaout_meterR

gaout_meterL = 0
gaout_meterL = 0

endin

instr 101

turnoff2 100,0,0

gkpeakinitL linseg i(gkpeakinitL), 0.2, 0
gkpeakinitR linseg i(gkpeakinitR), 0.2, 0

event_i "i",100, 0.2, 36000

endin

;STOP
instr 200

turnoff2 13,0,0
turnoff2 14,0,0
turnoff2 17,0,0
turnoff2 40,0,0

endin

</CsInstruments>
<CsScore>

f 1 0 1024 10 1

i 11 0 -1
i 16 0 -1
i 100 0 -1

e 36000

</CsScore>
</CsoundSynthesizer>

<bsbPanel>
<label>Widgets</label>
<objectName/>
<x>100</x>
<y>100</y>
<width>320</width>
<height>240</height>
<visible>true</visible>
<uuid/>
<bgcolor mode="nobackground">
<r>255</r>
<g>255</g>
<b>255</b>
</bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>

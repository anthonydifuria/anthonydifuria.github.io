<Cabbage>
form caption("Grande Eugenio") size(800, 350), guiMode("queue") pluginId("def1") colour(0,0,0)
rslider bounds(14, 12, 100, 100), channel("gkFreq"), range(50, 5000, 500, 1, 0.01), text("FREQUENCY"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(122, 14, 100, 100), channel("gkFreqSpread"), range(0, 40, 5, 1, 0.01), text("SPREAD FREQ"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(122, 114, 100, 100), channel("gkDur0"), range(0.01, 4, 3, 1, 0.01), text("DURATION"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(14, 114, 100, 100), channel("gkDens"), range(0.5, 50, 20, 1, 0.01), text("DENSITY"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(122, 216, 100, 100), channel("gkDurRand"), range(0, 1, 0.1, 1, 0.01), text("DUR RAND"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(14, 216, 100, 100), channel("gkDensRand"), range(0, 1, 0.1, 1, 0.01), text("DEN RAND"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)

rslider bounds(230, 158, 100, 100), channel("gkEnv"), range(0.001, 0.999, 0.5, 1, 0.001), text("ENV"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(348, 14, 100, 100), channel("gkGeoHarmSel"), range(0, 1, 1, 1, 0.01), text("GEO-HARM"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(244, 14, 100, 100), channel("gkGeo"), range(0.1, 2, 1, 1, 0.01), text("GEO"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(350, 158, 100, 100), channel("gkAM"), range(0, 1, 0, 1, 0.01), text("AM"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(450, 158, 100, 100), channel("gkFM"), range(0, 100, 0, 1, 0.01), text("FM"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(450, 14, 100, 100), channel("gkHarm"), range(1, 5, 4, 1, 1), text("VOICES"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)

rslider bounds(636, 14, 100, 100), channel("gkST"), range(0, 1, 1, 1, 0.01), text("ST RAND"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(580, 212, 100, 100), channel("gkRev"), range(0, 2, 0, 1, 0.01), text("REVERB"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)
rslider bounds(686, 212, 100, 100), channel("gkOut"), range(0, 2, 0.4, 1, 0.01), text("MASTER"), trackerColour(255, 165, 0, 255), outlineColour(255, 125, 0, 255), textColour(255, 165, 0, 255)


</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>

; Initialize the global variables. 
        ksmps = 32
        nchnls = 2
        0dbfs = 1

        seed 0
        
        gaL init 0
        gaR init 0
        
        instr 1
      
              gkFreq cabbageGetValue "gkFreq"
              gkFreqSpread cabbageGetValue "gkFreqSpread"
              gkDur0 cabbageGetValue "gkDur0"
              gkDens cabbageGetValue "gkDens"
              gkEnv cabbageGetValue "gkEnv"
              gkGeoHarmSel cabbageGetValue "gkGeoHarmSel"
              gkGeo cabbageGetValue "gkGeo"
              gkAM cabbageGetValue "gkAM"
              gkFM cabbageGetValue "gkFM"

              gkHarm cabbageGetValue "gkHarm"

              gkST cabbageGetValue "gkST"
              gkREV cabbageGetValue "gkRev"
              gkOut cabbageGetValue "gkOut"
              gkDurRand cabbageGetValue "gkDurRand" 
              gkDensRand cabbageGetValue "gkDensRand"
     
        endin

        instr 2

            kRandDens randomh -gkDensRand * gkDens, gkDensRand * gkDens, gkDens
            kDensTot = gkDens + kRandDens
            ktrig metro kDensTot
            kRandDur randomh -gkDurRand * gkDur0, gkDurRand * gkDur0, gkDens
            gkDur = gkDur0 + kRandDur 
  
            gkAmp = 1 / (1 + (kDensTot * gkDur))
            
            ;printk 0.5, gkAmp    
                
            schedkwhen ktrig, 0, 0, 3, 0, gkDur
            
            gkPartials randomh 0, gkHarm, gkDens
            gkSpreadFreq randomh -gkFreqSpread, gkFreqSpread, gkDens
         
            gkPan randomh 0.5 - (gkST * 0.5), 0.5 + (gkST * 0.5), gkDens

        endin

        instr 3

            aFM init 0
            aAM init 0

            ;ENV
            iAttPerc = i(gkEnv)
            iDurInf = (i(gkDur) / 4) * iAttPerc
            iDurSup = (i(gkDur) / 4) * (1 - iAttPerc)
            iRamp1 = 2
            iRamp2 = 0.5
            aEnv transeg 0, iDurInf, iRamp1, 0.5, iDurInf, iRamp2, 1,iDurSup, iRamp2, 0.5,iDurSup, iRamp1, 0

            ;HARM and GEO
            iHarm = int(i(gkPartials)) + 1
            iGeoPartials = int(i(gkPartials))
            iGeo = (i(gkGeo)) ^ iGeoPartials
            iSelGeoHarmm = iHarm * (i(gkGeoHarmSel)) + iGeo * (1 - i(gkGeoHarmSel))

            ;SPREAD FREQ
            iSpreadFreq = i(gkSpreadFreq)

            ;FREQ
            aFreq = ((i(gkFreq)) + iSpreadFreq) * iSelGeoHarmm

            ;AUTO MOD FREQ
            aModFreq = (aFM * aFreq * i(gkFM))
            
            ;MOD AM
            aAmpMod = aAM * i(gkAM)

            ;SIGNAL
            aSig oscili i(gkAmp) - aAmpMod ,aFreq + aModFreq
            aAM = aSig;FeedBack AM
            aFM = aSig;FeedBack FM
    
            ;SIGNAL OUT
            aOut = aSig * aEnv * (1 / iHarm)  

            ;PAN
            aL, aR pan2 aOut, i(gkPan) 

            ;OUT
            gaL = aL + gaL
            gaR = aR + gaR

        endin
        
        
        instr 50
        
        aL = gaL
        aR = gaR
        
        aRevL, aRevR freeverb aL, aR, 0.9, 0.5
        
        kREV portk gkREV, 0.1
        kOut portk gkOut, 0.1
        
        aSumL = (aL * kOut^6 + aRevL * kREV^6) / 2
        aSumR = (aR * kOut^6 + aRevR * kREV^6) / 2
        
        outs aSumL, aSumR
        
        gaL = 0
        gaR = 0
        
        endin
        
</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
i2 0 [60*60*24*7] 
i50 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>

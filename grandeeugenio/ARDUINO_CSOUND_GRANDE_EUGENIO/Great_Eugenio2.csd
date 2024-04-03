
<CsoundSynthesizer>
<CsOptions>
-d -odac -b341 -B682 -m0d 
</CsOptions>
<CsInstruments>

; Initialize the global variables.        
        sr = 48000
        ksmps = 128
        nchnls = 2
        0dbfs = 1
        
        seed 0

        gaL init 0
        gaR init 0

        opcode ArduinoSerial, k, kkiiii

            kSerial, kValue, ivalue, iChannel,iMin,iMax xin

                if(kValue = ivalue)then
                    if(kSerial != iChannel)then
                        kControl = kSerial   
                    endif
                    if(kControl > 190)then
                        kControl = 190   
                    endif
                    if(kControl < 5)then
                        kControl = 0   
                    endif
                endif
        
                kControlOut = (kControl / 190) * (iMax - iMin) + iMin
 
            xout kControlOut 
        endop
        
        instr 1
        
             
                   kCount init 0

            iPort serialBegin "/dev/ttyACM0", 9600;connect to the arduino with baudrate = 9600

            kval serialRead iPort
 
             if(kval != -1)then
                kvalPot = kval 
             endif

             if(kvalPot == 210)then
                kval2 = 0
             elseif(kvalPot == 211)then
                kval2 = 1
             elseif(kvalPot == 212)then
                kval2 = 2
             elseif(kvalPot == 213)then
                kval2 = 3
             elseif(kvalPot == 214)then
                kval2 = 4
             elseif(kvalPot == 215)then
                kval2 = 5
             elseif(kvalPot == 216)then
                kval2 = 6
             elseif(kvalPot == 217)then
                kval2 = 7
             elseif(kvalPot == 218)then
                kval2 = 8
             elseif(kvalPot == 219)then
                kval2 = 9
             elseif(kvalPot == 220)then
                kval2 = 10
             elseif(kvalPot == 221)then
                 kval2 = 11
             elseif(kvalPot == 222)then
                kval2 = 12
             elseif(kvalPot == 223)then
                kval2 = 13
             elseif(kvalPot == 224)then
                kval2 = 14
             endif
  
              gkFreq ArduinoSerial kvalPot, kval2,       0, 210, 50, 5000
              gkFreqSpread ArduinoSerial kvalPot, kval2, 1, 211, 0, 40
              gkDur0 ArduinoSerial kvalPot, kval2,       2, 212, 0.01, 4
              gkDurRand ArduinoSerial kvalPot, kval2,    3, 213, 0, 1
              gkDens ArduinoSerial kvalPot, kval2,       4, 214, 0.5, 50
              gkDensRand ArduinoSerial kvalPot, kval2,   5, 215, 0, 1
              gkEnv ArduinoSerial kvalPot, kval2,        6, 216, 0.001, 0.999
              gkGeoHarmSel ArduinoSerial kvalPot, kval2, 7, 217, 0, 1
              gkGeo ArduinoSerial kvalPot, kval2,        8, 218, 0.125, 2
              gkHarm ArduinoSerial kvalPot, kval2,       9, 219, 1, 5
              gkAM ArduinoSerial kvalPot, kval2,        10, 220, 0, 1
              gkFM ArduinoSerial kvalPot, kval2,        11, 221, 0, 100
              gkOut ArduinoSerial kvalPot, kval2,       12, 222, 0, 1
              gkST ArduinoSerial kvalPot, kval2,        13, 223, 0, 1
              gkREV ArduinoSerial kvalPot, kval2,       14, 224, 0, 1
              
              //printk 0.1, gkFreqSpread
   
     
        endin

        instr 2

            kRandDens randomh -gkDensRand * gkDens, 0, gkDens
            kDensTot = gkDens + kRandDens
            ktrig metro kDensTot
            kRandDur randomh -gkDurRand * gkDur0, 0, gkDens
            gkDur = gkDur0 + kRandDur 
  
            gkAmp = 1 / (1 + (kDensTot * gkDur))    	
                
            schedkwhen ktrig, 0, 0, 3, 0, gkDur
            
            gkPartials randomh 1, gkHarm, gkDens
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
            iHarm = int(i(gkPartials)) 
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
i1 0 -1 
i2 0 -1 
i50 0 -1
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
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>

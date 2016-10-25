# Strings
BENCH_PATH = MmaCOMPleib
RESULTS_PATH = results

SMALL = AC1.txt AC2.txt AC3.txt AC4.txt AC5.txt AC6.txt AC7.txt AC8.txt AC9.txt AC11.txt AC12.txt AC13.txt AC14.txt AC15.txt AC16.txt AC17.txt AC18.txt HE1.txt HE2.txt HE3.txt HE4.txt HE5.txt HE6.txt HE7.txt JE1.txt JE2.txt JE3.txt REA1.txt REA2.txt REA3.txt REA4.txt DIS1.txt DIS2.txt DIS3.txt DIS4.txt DIS5.txt TG1.txt AGS.txt WEC1.txt WEC2.txt WEC3.txt BDT1.txt MFP.txt UWV.txt IH.txt CSE1.txt EB1.txt EB2.txt EB3.txt EB4.txt EB5.txt PAS.txt TF1.txt TF2.txt TF3.txt PSM.txt NN1.txt NN2.txt NN3.txt NN4.txt NN5.txt NN6.txt NN7.txt NN8.txt NN9.txt NN10.txt NN11.txt NN12.txt NN13.txt NN14.txt NN15.txt NN16.txt NN17.txt HF2D_IS5.txt HF2D_IS6.txt HF2D_IS7.txt HF2D_IS8.txt HF2D_CD4.txt HF2D_CD5.txt HF2D_CD6.txt HF2D10.txt HF2D11.txt HF2D12.txt HF2D13.txt HF2D14.txt HF2D15.txt HF2D16.txt HF2D17.txt HF2D18.txt CM1.txt CM1_IS.txt TMD.txt FS.txt DLR1.txt DLR2.txt DLR3.txt LAH.txt ROC1.txt ROC2.txt ROC3.txt ROC4.txt ROC5.txt ROC6.txt ROC7.txt ROC8.txt ROC9.txt ROC10.txt

D12ISBOUNDED = AC2.txt AC3.txt AC4.txt AC5.txt AC6.txt AC7.txt AC8.txt AC10.txt AC11.txt AC13.txt AC14.txt AC15.txt AC16.txt AC17.txt AC18.txt HE1.txt HE2.txt HE3.txt HE4.txt HE5.txt HE6.txt HE7.txt JE1.txt JE2.txt JE3.txt REA1.txt REA2.txt REA3.txt REA4.txt DIS1.txt DIS2.txt DIS3.txt DIS4.txt DIS5.txt TG1.txt AGS.txt WEC1.txt WEC2.txt WEC3.txt HF1.txt BDT1.txt BDT2.txt MFP.txt IH.txt CSE1.txt CSE2.txt EB1.txt EB2.txt EB3.txt EB4.txt EB5.txt EB6.txt TF1.txt TF2.txt TF3.txt PSM.txt TL.txt CDP.txt NN1.txt NN2.txt NN4.txt NN5.txt NN6.txt NN7.txt NN8.txt NN12.txt NN13.txt NN14.txt NN15.txt NN16.txt NN18.txt HF2D_IS5.txt HF2D_IS6.txt HF2D_IS7.txt HF2D_IS8.txt HF2D_CD4.txt HF2D_CD5.txt HF2D_CD6.txt HF2D10.txt HF2D11.txt HF2D12.txt HF2D13.txt HF2D14.txt HF2D15.txt HF2D16.txt HF2D17.txt HF2D18.txt CM1.txt CM2.txt CM3.txt CM4.txt CM5.txt CM6.txt CM1_IS.txt CM2_IS.txt CM3_IS.txt CM4_IS.txt CM5_IS.txt CM6_IS.txt TMD.txt FS.txt DLR1.txt DLR2.txt DLR3.txt ISS1.txt ISS2.txt CBM.txt LAH.txt ROC3.txt

D12ISBOUNDEDSMALL = AC2.txt AC3.txt AC4.txt AC5.txt AC6.txt AC7.txt AC8.txt AC11.txt AC13.txt AC14.txt AC15.txt AC16.txt AC17.txt AC18.txt HE1.txt HE2.txt HE3.txt HE4.txt HE5.txt HE6.txt HE7.txt JE1.txt JE2.txt JE3.txt REA1.txt REA2.txt REA3.txt REA4.txt DIS1.txt DIS2.txt DIS3.txt DIS4.txt DIS5.txt TG1.txt AGS.txt WEC1.txt WEC2.txt WEC3.txt BDT1.txt MFP.txt IH.txt CSE1.txt EB1.txt EB2.txt EB3.txt EB4.txt EB5.txt TF1.txt TF2.txt TF3.txt PSM.txt NN1.txt NN2.txt NN4.txt NN5.txt NN6.txt NN7.txt NN8.txt NN12.txt NN13.txt NN14.txt NN15.txt NN16.txt HF2D_IS5.txt HF2D_IS6.txt HF2D_IS7.txt HF2D_IS8.txt HF2D_CD4.txt HF2D_CD5.txt HF2D_CD6.txt HF2D10.txt HF2D11.txt HF2D12.txt HF2D13.txt HF2D14.txt HF2D15.txt HF2D16.txt HF2D17.txt HF2D18.txt CM1.txt CM1_IS.txt TMD.txt FS.txt DLR1.txt DLR2.txt DLR3.txt LAH.txt ROC3.txt

AC = AC3.txt AC4.txt AC6.txt
EB = EB1.txt EB2.txt EB3.txt

# Main guy
all: ac eb

small: $(SMALL)

bounded: $(D12ISBOUNDED)

boundedsmall: $(D12ISBOUNDEDSMALL)

ac: $(AC)

eb: $(EB)

clean:
	rm -f results/*

# rules
%.txt: $(BENCH_PATH)/%.m 
	math $(BENCH_PATH)/$* $(RESULTS_PATH)/$*.m $(RESULTS_PATH)/summary.txt $(RESULTS_PATH)/results.txt < COMPleib_Run.m > $(RESULTS_PATH)/$*.txt

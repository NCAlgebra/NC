include ../make.inc

FILES = AdmWithLevels.o \
AdmissibleOrder.o \
MainFunctionRoutine.o \
AllTimings.o \
AltInteger.o \
AppendItoString.o \
AsciiOutputVisitor.o \
AuxilaryData.o \
BaRoutineFactory.o \
ByAdmissible.o \
Categories.o \
CntSource.o \
Command.o \
CommandPlace.o \
Commands.o \
CompareOnDouble.o \
ComparisonExtended.o \
Composite.o \
CountDup.o \
CountDupError.o \
CountSink.o \
CountSource.o \
CountedError.o \
CreateNewFactory.o \
CreateNumber.o \
CreateOrder.o \
DataConversions.o \
Debug1.o \
Debug2.o \
Debug3.o \
Documentation.o \
DoubleDispatch.o \
FCGiveNumber.o \
FactBase.o \
FactControl.o \
Field.o \
GBGlobals.o \
GBHistory.o \
GBInput.o \
GBInputNumbers.o \
GBListError.o \
GBMatch.o \
GBOutput.o \
GBStream.o \
GBString.o \
General.o \
GeneralMora.o \
Generator.o \
GiveNumber.o \
GiveTips.o \
GrabVariables.o \
Graph.o \
GraphWalk.o \
GroebnerRule.o \
Holder.o \
ISink.o \
ISource.o \
IISource.o \
ItoString.o \
KludgeHistory.o \
MLex.o \
MatcherMonomial.o \
MemoryOptions.o \
MmaSink.o \
MmaSource.o \
MngrStart.o \
MngrSuper.o \
Monomial.o \
MonomialToPowerList.o \
MoraWorkHorse.o \
MyInteger.o \
MyOstream.o \
NCGBVariablesValues.o \
OfstreamProxy.o \
OrderReduction.o \
OrderType.o \
Orders.o \
OuMonomial.o \
OuTerm.o \
OutputVisitor.o \
Ownership.o \
PDGenerator.o \
PDReduction.o \
PDRoutineFactory.o \
Pause.o \
PlatformSpecific.o \
Polynomial.o \
PoolError.o \
PrintGBList.o \
PrintGBVector.o \
PrintList.o \
PrintOrder.o \
PrintVector.o \
RAList.o \
RecordHere.o \
Reduction.o \
RuleInformation.o \
SPIID.o \
STRING.o \
SelectRules.o \
SetMLex.o \
SetNCGBCommutative.o \
SetSlot.o \
SetSource.o \
SimpleTableError.o \
Source.o \
StartEnd.o \
StringAccumulator.o \
TellHead.o \
Term.o \
TestMarker.o \
Timers.o \
Timing.o \
UnifierBin.o \
UniqueList.o \
UserOptions.o \
Utilities.o \
VarValues.o \
VarValuesDocumentation.o \
Variable.o \
VariableSet.o \
VersionControl.o \
adjoint.o \
backspacer.o \
constiterGBVectorError.o \
expandVector.o \
firstDiffer.o \
gcd.o \
idValue.o \
intpair.o \
marker.o \
nDataMonomial.o \
ncgbofstream.o \
p10aux.o \
p11aux.o \
p13aux.o \
p1aux.o \
p3aux.o \
p6aux.o \
p7aux.o \
p8aux.o \
p9aux.o \
paux.o \
pauxvar.o \
setStartingRelations.o \
simpleString.o \
sortaux.o \
stringGB.o \
subMonomial.o \
vectortemplates.o 

all: p9c

ncgbfrontendtm.cpp: ncgbfrontend.tm
	$(MPREP) -prototypes $? -o $@

p9c: ncgbfrontendtm.cpp $(FILES) 
	$(CC) $(CCFLAGS) -o $@ $(FILES) $(LIBS)
	mkdir -p ../../Binary/p9c/$(PLAT)
	cp $@ ../../Binary/p9c/$(PLAT)/.

clean:
	rm -f *.o p9c

wipe: clean
	rm -f ncgbfrontendtm.cpp

.cpp.o:
	$(CC) $(CCFLAGS) -c $<

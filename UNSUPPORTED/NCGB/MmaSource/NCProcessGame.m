NCProcess1[aList_,n_,filename_,rules___Rule]:=
   NCProcess[aList,n,filename,SBByCat->True,RR->True,rules];

NCProcess2[aList_,n_,filename_,rules___Rule]:=
   NCProcess[aList, n, filename,SB->True,RR->True,rules];

NCProcessMidGame[x__] :=  NCProcess1[x];
NCProcessEndGame[x__] :=  NCProcess2[x];

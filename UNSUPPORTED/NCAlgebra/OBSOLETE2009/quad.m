quad[anArray_Symbol,aList_List] :=
Module[{len,tpvars,nontpvars,result,tempx,i,j,
        theAnswer,aTpVar,aNonTpVar,marker},
     len = Length[aList];
     tpvars = Table[If[OddQ[i],{aList[[i]]},{}],{i,1,len}];
     nontpvars = Table[If[EvenQ[i],{aList[[i]]},{}],{i,1,len}];
     result = Table[tempx[i,j],{i,1,len/2},{j,1,len/2}];
     Do[ 
        Do[ aTpVar = tpvars[[i]];
            aNonTpVar = nontpvars[[j]];
            marker = Table[0,{i,1,len}];
            marker[[2 i - 1]] = 1;
            marker[[2 j]] = 1;
            ans = NCTaylorTermArray[anArray,aList,marker];
            tempx[j,i] = ans;
        ,{i,1,len/2}];
     ,{j,1,len/2}];
     theAnswer = result;
     Clear[tempx];
     Return[theAnswer];
];

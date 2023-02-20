
oldmem = 0;
oldcmem = 0;

mem[] :=
  ( newmem = MemoryInUse[];
    newcmem = CPlusPlusMemoryUsage[];
    Print[newmem - oldmem,",",newcmem-oldcmem];
    oldmem  = newmem;
    oldcmem = newcmem;);
mem[x___] := BadCall["mem",x];

PrependTo[$Path,"/home/oba/mstankus/UCSD_JOB/smallMora/newcode/preNF"];

<<GB.atom;
ClearDataBase[];

UseToReduce = 
{
RuleTuple[Inv[1 - x ** y] ** x -> x ** Inv[1 - y ** x], {}, {}]
};

UseToReduce = Flatten[Map[AddToDataBase,UseToReduce]];

Print[UseToReduce];

ThingsToReduce =
{
RuleTuple[Inv[1 - x ** y] ** x ** (Inv[1 - y ** x]^2) -> 
    x ** (Inv[1 - y ** x]^3) , {}, {}]
};

ThingsToReduce = Flatten[Map[AddToDataBase,ThingsToReduce]];

Print[ThingsToReduce];

ans = Reduction[ThingsToReduce,UseToReduce];

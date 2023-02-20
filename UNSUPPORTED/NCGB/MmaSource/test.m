Get["NCGB.m"];

aList = {x**x-a};
SetMonomialOrder[{a,x}];

RegularOutput[aList,"test_result","C++"];

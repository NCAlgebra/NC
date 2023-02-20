SetMonomialOrder[{a,b,x,z,y},1];

data  = {x**z,z**x-x+a, y**x - x**x - b, x**y};

ans = NCMakeRules[data,3];

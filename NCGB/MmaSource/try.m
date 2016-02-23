<<NCGB.m;
ClearMonomialOrder[];

SetMonomialOrder[{x,y}];

rel = {x**y - y** x - 1,
x**x**x-y**y**y};

ans = NCMakeGB[rel,4];

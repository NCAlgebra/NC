SNC[A,B,C0,DD,ACROSS, proj1,proj2,leftm1,leftm2,rightm1,rightm2,a,b,c,e,f,g,m1,m2];

cheat={
	m1**leftm1-> proj1,
	B**C0 -> ACROSS + A,
	m2**leftm2 -> proj2
      };

smallset={
	proj2 -> 1 - proj1,
	rightm1 -> leftm1,
	rightm2 -> leftm2,
	b -> leftm1 ** B,
	c -> C0 ** m1,
	f -> leftm2 ** B,
	g -> C0 ** m2,
	a -> leftm1 ** A ** m1,
	e -> leftm2 ** A ** m2,
	proj1**proj1 -> proj1,
	proj1**A**proj1 -> proj1**A,
	proj1**ACROSS**proj1->ACROSS**proj1,
	leftm1**m1->1,
	leftm2**m2 ->1,
	proj1**m2 -> 0
};

rels=Join[smallset,cheat];

setOne={A,B,C0,DD,ACROSS};
setTwo={proj1,proj2};
setFour={leftm1,leftm2};
setFive={rightm1,rightm2};
setSix={a,b,c,e,f,g};
setThree={m1,m2};

SetMonomialOrder[setOne,1];
SetMonomialOrder[setTwo,2];
SetMonomialOrder[setThree,3];
SetMonomialOrder[setFour,4];
SetMonomialOrder[setFive,5];
SetMonomialOrder[setSix,6];
Iterations=2;

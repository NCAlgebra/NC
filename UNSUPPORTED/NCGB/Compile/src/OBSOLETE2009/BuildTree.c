// Mark Stankus 1999 (c)
// BuildTree.c


#include "SFSGNode.hpp"
#include <stdlib.h>
#include "MonomialForest.hpp"
extern MonomialForest * s_forest_p;
#include "PrintVector.hpp"
#include "UglySheet.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "ByAdmissible.hpp"
#include "GBInput.hpp"
#include "AdmissibleOrder.hpp"
#include "ByAdmissible.hpp"
#include "stringGB.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#include <multiset>
#else
#include <map.h>
#include <multiset.h>
#endif

void PrintAllTrees();

struct BuildTreeError {
  static void errorh(int n) { DBGH(n);};
  static void errorc(int n) { DBGC(n);};
};

#ifdef DEBUG_SFSGNODE
int SFSGNode::s_number = 0;
#endif

void _BuildTree(Source & so,Sink & si) {
  system("rm answers/typescript.*");
  system("rm answers/*.html");
  MonomialForest forest;
  s_forest_p = &forest;
  list<Polynomial> L;
  stringGB typestring;
  MonomialForest::AlgorithmApproach style;
  int n;
  stringGB dir;
  so >> typestring >> n;
  if(typestring=="INLIST") {
    style  = MonomialForest::INLIST;
  } else if(typestring=="INFOREST") {
    style = MonomialForest::INFOREST;
  } else {
    GBStream << "Invalid algorithm type:" << typestring 
             << "\nChoose either INLIST or INFOREST" << '\n';
    BuildTreeError::errorc(__LINE__); 
  };
  GBInputSpecial(L,so);
  so >> dir;
  so.shouldBeEnd();
  si.noOutput();  
  if(n<0) {
    GBStream << "Executing BuildTree for " << n 
             << " iterations is not allowed since " << n << " < 0\n";
    BuildTreeError::errorc(__LINE__);
  };
  list<Polynomial>::const_iterator w = L.begin(), e = L.end();
  while(w!=e) {
    forest.addPolynomial(*w);
    ++w;
  };
  forest.fixTree();
  while(n) {
    GBStream << "R:Have " << n << "iterations to go:\n";
    forest.PrintAllTrees(GBStream,HTML);
    forest.PrintTheSet(GBStream);
    forest.makeRecent(style);
    forest.fixTree();
    --n;
  };
  GBStream << "****************\n";
  forest.PrintAllTrees(GBStream,HTML);
  GBStream << "****************\n";
  L.erase(L.begin(),L.end());
  forest.copyIntoList(L);
  UglySheet(dir.value().chars(),L);
};

AddingCommand temp1MonomialTree("BuildTree",4,_BuildTree);

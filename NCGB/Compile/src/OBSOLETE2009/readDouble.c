#include "GraphVertex.hpp"
#include "ColoredGraph.hpp"
#include "TriColor.hpp"
#include "readDoubleColumnGraph.hpp"
#include "readSingleColumn.hpp"
#include "readMultiColumn.hpp"
#include <assert.h>
#include "Choice.hpp"
#ifdef INCLUDE_HAS_NO_DOTS
#include <fstream>
#include <string>
#include <set>
#include <list>
#include <iterator>
#include <algorithm>
#else
#include <fstream.h>
#include <string.h>
#include <set.h>
#include <list.h>
#include <iterator.h>
#include <algo.h>
#endif

void printset(ostream & os,const set<GraphVertex,less<GraphVertex> > & x,
    const char * filler,const char * endfiller="\n") {
  set<GraphVertex,less<GraphVertex> >::const_iterator w = x.begin(), e = x.end();
  while(w!=e) {
    os << (*w).d_s.c_str();
    ++w;
    if(w!=e) os << filler;
  };
  os << endfiller;
};

bool isSelected(set<GraphVertex,less<GraphVertex> > & L,const string  & s) {
  cerr << "checking " << s.c_str() << " selected?\n";
  bool result = false;
  typedef set<GraphVertex,less<GraphVertex> >::const_iterator LI;
  LI w = L.begin(), e = L.end();
  while(w!=e) {
    if((*w).d_s==s) {
      result = true;
      break;
    };
    ++w;
  };
  cerr << (result ? "yes\n" : "no\n");
  return result;
};

bool addElements(ColoredGraph<GraphVertex,TriColor> & gr,
    const TriColor & color,set<GraphVertex,less<GraphVertex> > & S,
    const list<list<string> > & Dbllist) {
  bool result = false;
  typedef list<list<string> >::const_iterator LLI;
  typedef list<string>::const_iterator LI;
  if(Dbllist.size()%2==1) {
    cerr << "Exit since file wrong size " << Dbllist.size() << "\n";
    exit(-222);
  };
  LLI w = Dbllist.begin(), e = Dbllist.end();
  while(w!=e) {
    const list<string> & x = *w;
    LI ww = x.begin(), ee = x.end();
    while(ww!=ee) {
      cerr << "did:" << (*ww).c_str() << '\n';
      ++ww;
    };
    ww = x.begin(); ee = x.end();
    while(ww!=ee && isSelected(S,*ww)) { ++ww;};
    bool addextra = ww==ee;
    ++w;
    if((*w).size()!=1) {    
      cerr << "Incorrect file\n";
      exit(-222);
    };
    if(addextra) {
      const string & extra = * (*w).begin();
      GraphVertex vert(extra);
      if(S.find(vert)==S.end()) {
        cerr << "Adding " << extra.c_str() << '\n';
        result = true;
        S.insert(vert);
        gr.colorVertex(vert,color);
      };
    } else {
      cerr << "Failed on " << (*ww).c_str() << '\n';
    };
    ++w;
  };
  return result;
};
  
int main() {
  ColoredGraph<GraphVertex,TriColor> gr;
  set<GraphVertex,less<GraphVertex> > groupsall, filesall,functionsall;
  set<GraphVertex,less<GraphVertex> > groupssome, filessome,functionssome,S;
  set<GraphVertex,less<GraphVertex> > groupsnot, filesnot,functionsnot;
  ifstream ifs1("groups.txt");
  ifstream ifs2("files.txt");
  ifstream ifs3("files.txt");
  ifstream ifs4("choices.txt");
  cerr << "reading groups";
  readDoubleColumnGraph(ifs1,groupsall,gr,true);
  cerr << ", files";
  readDoubleColumnGraph(ifs2,filesall,gr,true);
  cerr << ", functions\n";
  readDoubleColumnGraph(ifs3,functionsall,gr,false);
  readSingleColumn(ifs4,gr);
#if 1
  ifstream ifs5("depends.txt");
  list<list<string> > dbllist;
  readMultiColumns(ifs5,dbllist);
#endif
  bool todo  = true;
  while(todo) {
    todo = false;
    gr.ColorChildComponents(TriColor::s_one,TriColor::s_two);
    list<GraphVertex> L(gr.getColored(TriColor::s_two));
    copy(L.begin(),L.end(),inserter(S,S.begin()));
#if 1
    todo = addElements(gr,TriColor::s_one,S,dbllist);
    cerr << "addelements give " << todo << '\n';
#endif
  };
  cerr << "Here is the set after the loop:\n";
  printset(cerr,S,",");
  set_intersection(S.begin(),S.end(),groupsall.begin(),groupsall.end(),
                   inserter(groupssome,groupssome.begin()));
  set_intersection(S.begin(),S.end(),filesall.begin(),filesall.end(),
                   inserter(filessome,filessome.begin()));
  set_intersection(functionsall.begin(),functionsall.end(),S.begin(),S.end(),
                   inserter(functionssome,functionssome.begin()));
  set_difference(groupsall.begin(),groupsall.end(),S.begin(),S.end(),
                   inserter(groupsnot,groupsnot.begin()));
  set_difference(filesall.begin(),filesall.end(),S.begin(),S.end(),
                   inserter(filesnot,filesnot.begin()));
  set_difference(functionsall.begin(),functionsall.end(),S.begin(),S.end(),
                   inserter(functionsnot,functionsnot.begin()));
  cerr << "all groups:\n";
  printset(cerr,groupsall,", ");
  cerr << "\nall files:\n";
  printset(cerr,filesall,", ");
  cerr << "\nall functions:\n";
  printset(cerr,functionsall,", ");
  cerr << "\n\n\n";
  cerr << "groups (not):\n";
  printset(cerr,groupsnot,", ");
  cerr << "\nfiles (not):\n";
  printset(cerr,filesnot,", ");
  cerr << "\nfunctions(not):\n";
  printset(cerr,functionsnot,", ");
  cerr << "\n\n\n";
  cerr << "groups:\n";
  printset(cerr,groupssome,", ");
  cerr << "\nfiles:\n";
  printset(cerr,filessome,", ");
  cerr << "\nfunctions:\n";
  printset(cerr,functionssome,", ");

  cerr << "Staring creation of the file Makefile.mark\n";
  ofstream ofs("Makefile.mark");
  ofs << "p9clist = ";
  printset(ofs,filessome,".o \\\n",".o \n");
  ofs.close();
  cerr << "Ended creation of the file Makefile.mark\n";

  cerr << "Staring creation of the file Makefile.cp\n";
  ofstream ofs2("Makefile.cp");
  ofs2 << "cp ";
  printset(ofs2,filessome,".[hc]pp copyplace/ \n cp ",".[hc]pp copyplace/ \n");
  ofs2.close();
  cerr << "Ended creation of the file Makefile.cp\n";
};

#include "Choice.hpp"
#ifdef USE_UNIX
#include "ColoredGraph.c"
#else
#include "ColoredGraph.cpp"
#endif
bool ColoredGraph<GraphVertex,TriColor>::s_includecolor = false;
template class ColoredGraph<GraphVertex,TriColor>;

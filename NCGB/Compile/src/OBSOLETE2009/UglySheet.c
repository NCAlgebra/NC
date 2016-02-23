// Mark Stankus 1999 (c)
// UglySheet.cpp


char * Colors[] = {"black","maroon","red","purple","fuchsia",
    "green","lime","olive","navy","blue","teal","aqua",0};

const char * s_start_htmlfile = "<html><body bgcolor=\"#FFFFFF\" TEXT=\"#000000\" LINK=\"#1F00FF\" ALINK=\"FF0000\" VLINK=\"9900DD\">\n";

#include "PrintList.hpp"
#include "ItoString.hpp"
#include "VariableSet.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "stringGB.hpp"
#include "Names.hpp"
#include "AdmWithLevels.hpp"
#include "GrabVariables.hpp"
#include "SFSGRules.hpp"
#include "MonomialToPowerList.hpp"
#include "MyOstream.hpp"
#include "Polynomial.hpp"
#include "ByAdmissible.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#include <set>
#include <map>
#include <fstream>
#else
#include <list.h>
#include <set.h>
#include <map.h>
#include <fstream.h>
#endif

//#define PLAIN_HTML

void RemoveZeros(list<Polynomial> & M) {
  list<Polynomial>::iterator w = M.begin(), e = M.end();
  while(w!=e) {
    if((*w).zero()) {
      w = M.erase(w);
    } else ++w;
  };
};

void ExtractSingletons(list<Polynomial> & M,list<Polynomial> & result) {
  list<Polynomial>::iterator w = M.begin(), e = M.end();
  while(w!=e) {
    const Polynomial & p = *w;
    if(p.tipMonomial().numberOfFactors()==1) {
      result.push_back(p); 
      w = M.erase(w);
    } else ++w;
  };
};

void  ExtractCategories(list<Polynomial> & M,
   map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> & result,
   int num,const VariableSet & unk) {
  typedef list<Polynomial>::iterator LI;
  LI w = M.begin(), e = M.end();
  while(w!=e) {
    const Polynomial & p = *w; 
    VariableSet V; 
    GrabVariables(p,V);
    V.intersection(unk);
    if(V.size()==num) {
      map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible>::iterator f;
      f = result.find(V);
      if(f==result.end()) {
        set<Polynomial,ByAdmissible> S;
        S.insert(p); 
        pair<const VariableSet,set<Polynomial,ByAdmissible> > pr(V,S);
        result.insert(pr);
      } else {
        (*f).second.insert(p);
      }; 
      w = M.erase(w);
    } else ++w;
  }; // while(w!=e) 
};
void uglyPrint(MyOstream & os,const Variable & x,
    const VariableSet & unk) {
#ifdef PLAIN_HTML
  os << x;
#else
  if(unk.present(x)) {
    os << "<font color=\"red\">" << x << "</font>\n";
  } else {
    os << x;
  };
#endif
};

void uglyPrint(MyOstream & os,const Monomial & x,
    const VariableSet & unk) {
#ifdef PLAIN_HTML
  os << x;
#else
  const int num = x.numberOfFactors();
  if (num == 0) {
    os << '1';
  } else {
    list<pair<Variable,int> > L;
    MonomialToPowerList(x,L);
    list<pair<Variable,int> >::const_iterator w = L.begin();
    const int treesSizem1 = L.size()-1;
    for(int i=1;i<=treesSizem1;++i,++w) {
      const pair<Variable,int> & pr = *w;
      uglyPrint(os,pr.first,unk);
      if(pr.second!=1) {
        os << '^' << pr.second;
      }
      os << (pr.first.commutativeQ() ? " * " : " ** ");
    };
    const pair<Variable,int> & pr = *w;
    uglyPrint(os,pr.first,unk);
    if(pr.second!=1) {
      os << '^' << pr.second;
    }
  }
#endif
};

void uglyPrint(MyOstream & os,const Term & x,
    const VariableSet & unk) {
#ifdef PLAIN_HTML
  os << x;
#else
  const Monomial & m = x.MonomialPart();
  if(! x.CoefficientPart().one()) {
    x.CoefficientPart().print(os);
    os << ' ';
    if(!m.one()) uglyPrint(os,m,unk);
  } else {
    uglyPrint(os,m,unk);
  };
#endif
};

void uglyPrint(MyOstream & os,const Polynomial & x,
    const VariableSet & unk) {
#ifdef PLAIN_HTML
  os << x;
#else
  PolynomialIterator i = x.begin();
  const int len = x.numberOfTerms();
  if(len==0) {
    os << '0';
  } else {
    uglyPrint(os,*i,unk);
    ++i;
    for(int k=2;k<=len;++k,++i) {
      const Term & t = *i;
      if(t.CoefficientPart().sgn()<=0) {
        os << " - ";
        uglyPrint(os,- t,unk);
      } else {
        os << " + ";
        uglyPrint(os,t,unk);
      }
    }
  }
#endif
};

void  PrintSingleTons(MyOstream & os,
     const list<Polynomial> & singles,const VariableSet & unk,bool sep) {
  if(!sep) {
    os << "<a name=\"singletons\">";
  };
  os << "<center>Singletons</center>\n";
  if(!sep) {
    os << "</a>\n";
  };
  typedef list<Polynomial>::const_iterator LI; 
  LI w = singles.begin(), e = singles.end();
  while(w!=e) {
    const Polynomial & p = *w; 
    uglyPrint(os,p,unk);
    os << "<br>\n\n";
    ++w;
  };
};

void PrintCategory(MyOstream & os,
   const VariableSet & V,const set<Polynomial,ByAdmissible> & S
   ,const VariableSet & unk,const char * curlyname) {
  typedef set<Polynomial,ByAdmissible> SET;
  typedef SET::iterator SI; 
  SI w = S.begin(), e = S.end();
  while(w!=e) {
    os << "<table><tr><td> ";
    uglyPrint(os,*w,unk);
    os << "</td></tr></table><br>\n";
    ++w;
  };
};

void PrintNumberSummary(MyOstream & os,
   const map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> & wait,
   const VariableSet & unk,int num,bool sep) {
  typedef set<Polynomial,ByAdmissible> SET;
  typedef map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> MAP;
  typedef list<Polynomial>::iterator LI; 
  typedef map<VariableSet,set<Polynomial,ByAdmissible>,
              ByAdmissible>::const_iterator MCI;
  MCI w = wait.begin(), e = wait.end();
  while(w!=e) {
    const pair<const VariableSet,set<Polynomial,ByAdmissible> > & pr = *w;
    const VariableSet & V = pr.first;
    os << "&nbsp;&nbsp;<a href=\""; 
    if(!sep) os << '#';
    os << "category" << V.toString('\0',',','\0');
    if(sep) os << ".html";
    os << "\">" 
       << V << "</a>\n<br>\n";
    ++w;
  };
};

void PrintNumberCategory(MyOstream & os,const char * directoryname,
   const map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> & wait,
   const VariableSet & unk,int num,bool sep) {
  typedef set<Polynomial,ByAdmissible> SET;
  typedef map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> MAP;
  typedef list<Polynomial>::iterator LI; 
  typedef map<VariableSet,set<Polynomial,ByAdmissible>,
              ByAdmissible>::const_iterator MCI;
  MCI w = wait.begin(), e = wait.end();
  while(w!=e) {
    const pair<const VariableSet,set<Polynomial,ByAdmissible> > & pr = *w;
    const VariableSet & V = pr.first;
    char * curlyname = V.toString();
    if(sep) {
      char * name = V.toString('\0',',','\0');
      char * prefix = "category";
      char * suffix = ".html";
      char * pagename = 
         new char[strlen(directoryname)+1+
                  strlen(name)+strlen(prefix) + strlen(suffix)];
      strcpy(pagename,directoryname);
      strcat(pagename,prefix);
      strcat(pagename,name);
      strcat(pagename,suffix);
      ofstream page(pagename);
      MyOstream os2(page);
      os2 << s_start_htmlfile;
      os2 << "<center> Category with unknowns " <<  curlyname 
          << "</center><br>\n";
      PrintCategory(os2,V,pr.second,unk,curlyname);
      os2 << "</body></html>\n";
      delete [] pagename;
      delete [] curlyname;
      delete [] name;
      page.close();
    } else {
      os << "<a name=\"category" << curlyname
         << "\"><center> Category with unknowns " <<  curlyname 
          << "</center></a><br>\n";
      PrintCategory(os,V,pr.second,unk,curlyname);
      os << "<br><hr>\n";
    };
    ++w;
  };
};

void UglySeperatePages(MyOstream & index,const char * directoryname,
    const list<Polynomial> & singles,const VariableSet & unk,
    vector<map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> *> vec) {
  index << s_start_htmlfile;
  index << "Order:"; 
  AdmissibleOrder::s_getCurrent().PrintOrder(index);
  index << "<br>\n";
  if(singles.empty()) {
    index << "No singletons\n<br>\n";
  } else { 
    char * name = "singletons.html";
    char * pagename = 
         new char[strlen(directoryname)+1+strlen(name)];
    strcpy(pagename,directoryname);
    strcat(pagename,name);
    index << "<a href=\"" << pagename << "\">Singletons</a><br>\n";
    delete [] pagename;
  };
  vector<map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> *>::
      const_iterator w =  vec.begin(), e = vec.end();
  int i=0;
  while(w!=e) {
    const map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> & MAP 
       = *(*w);
    if(MAP.empty()) {
      index << "No categories with " << i << " categories.\n<br>\n";
    } else {
      if(MAP.size()==1) {
        index << "Category";
      } else {
        index << "Categories";
      };
      index << " with " << i << " unknowns </a><br>\n";
      PrintNumberSummary(index,MAP,unk,i,true);
    };
    ++w;++i;
  };
  if(!singles.empty()) {
    {
    char * name = "singletons.html";
    char * pagename = 
         new char[strlen(directoryname)+1+strlen(name)];
    strcpy(pagename,directoryname);
    strcat(pagename,name);
    ofstream ofs(pagename);
    MyOstream singleos(ofs); 
    delete [] pagename;
    singleos << s_start_htmlfile;
    PrintSingleTons(singleos,singles,unk,true);
    singleos << "</body></html>\n";
    ofs.close();
    };
  };
  w =  vec.begin(); e = vec.end();
  i=0;
  while(w!=e) {
    const map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> & MAP 
       = *(*w);
    if(!MAP.empty()) {
      PrintNumberCategory(index,directoryname,MAP,unk,i,true);
    };
    ++w;++i;
  };
};

void UglySinglePage(const char * directoryname,const char * name,
    const list<Polynomial> & singles,const VariableSet & unk,
    vector<map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> *> vec) {
  char * pathname = new char[strlen(directoryname)+strlen(name)+1];
  strcpy(pathname,directoryname);
  strcat(pathname,name);
  ofstream ofs(pathname);
  delete [] pathname;
  MyOstream os(ofs);
  os << s_start_htmlfile;
  os << "\nOrder:"; 
  AdmissibleOrder::s_getCurrent().PrintOrder(os);
  os<< "<br>\n";
  if(singles.empty()) {
    os << "No singletons\n<br>\n";
  } else { 
    os << "<a href=\"#singletons\">Singletons</a><br>\n";
  };
  vector<map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> *>::
      const_iterator w =  vec.begin(), e = vec.end();
  int i=0;
  while(w!=e) {
    const map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> & MAP 
       = *(*w);
    if(MAP.empty()) {
      os << "No categories with " << i << " categories.\n<br>\n";
    } else {
      if(MAP.size()==1) {
        os << "Category";
      } else {
        os << "Categories";
      };
      os << " with " << i << " unknowns </a><br>\n";
      PrintNumberSummary(os,MAP,unk,i,false);
    };
    ++w;++i;
  };
  os << "<br><hr>\n";
  if(!singles.empty()) {
    PrintSingleTons(os,singles,unk,false);
    os << "<br><hr>\n";
  };
  w =  vec.begin(); e = vec.end();
  i=0;
  while(w!=e) {
    const map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> & MAP 
       = *(*w);
    if(!MAP.empty()) {
      PrintNumberCategory(os,directoryname,MAP,unk,i,false);
      os << "<br><hr>\n";
    };
    ++w;++i;
  };
};

void UglySheet(const char * directoryname,const list<Polynomial> & L) {
  VariableSet unk(((AdmWithLevels &)AdmissibleOrder::s_getCurrent()).Unknowns());
  list<Polynomial> M(L),singles;
  RemoveZeros(M);
  ExtractSingletons(M,singles);
  vector<map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> *>
       categ_vec;
  map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible> * MM;
  int numunknowns = 0;
  while(!M.empty()) {
    MM   = new map<VariableSet,set<Polynomial,ByAdmissible>,ByAdmissible>;
    ExtractCategories(M,*MM,numunknowns,unk);
    categ_vec.push_back(MM);
    ++numunknowns;
  };
  char * name1 = "index.html";
  char * indexname = 
       new char[strlen(directoryname)+1+strlen(name1)];
  strcpy(indexname,directoryname);
  strcat(indexname,name1);
  ofstream ofs(indexname);
  MyOstream index(ofs);
  UglySeperatePages(index,directoryname,singles,unk,categ_vec);
  const char * name2 = "allinone.html";
  index << "<br><hrule>\n";
  index << "<a href=\"" << name2 << "\">All as one big page</a>\n";
  UglySinglePage(directoryname,name2,singles,unk,categ_vec);
  index << "</body></html>\n";
  ofs.close();
};


void _UglyFromSFSGRules(Source & so,Sink & si) {
  stringGB sfsgname;
  so >> sfsgname;
  si.noOutput();
  SFSGRules * r = (SFSGRules *) Names::s_lookup_error(GBStream,
        sfsgname.value().chars(),"SFSRules").ptr();
  if(!r) DBG();
  list<Polynomial> L;
  r->copyToList(L);
  UglySheet("/home/mstankus/current/work/answers/",L);
};

AddingCommand temp1Ugly("UglyFromSFSGRules",1,_UglyFromSFSGRules);

#include "GBInput.hpp"

void _UglyFromList(Source & so,Sink & si) {
  stringGB x;
  list<Polynomial> L;
  so >> x;
  GBInputSpecial(L,so);
  si.noOutput();
  UglySheet(x.value().chars(),L);
};

AddingCommand temp2Ugly("UglyFromList",2,_UglyFromList);

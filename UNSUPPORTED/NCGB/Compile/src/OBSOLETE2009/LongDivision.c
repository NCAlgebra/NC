// Mark Stankus 1999 (c)
// LongDivision.c


#include "Variable.hpp"
#include "Polynomial.hpp"
#include "PrintingEnvironment.hpp"
#include "Command.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "stringGB.hpp"
#include "MyOstream.hpp"
#include "Choice.hpp"
#ifdef INCLUDE_HAS_NO_DOTS
#include <iostream>
#include <fstream>
#else
#include <iostream.h>
#include <fstream.h>
#endif

//#define USEASCII
#define USEHTML

char * tableString = "<table border>";

void PrintPoly(MyOstream & os,const Polynomial & p,int n,
    const char * tipbefore,const char * tipafter,
    const char * otherbefore, const char * otherafter) {
#if 0
  os << "<td colspan=\"" << n << "\">"; // quot displayed
  os << tableString << "<tr>";
  os << "<td>" << p << "</td>";
  os << "</tr></table>\n";
  os << "</td>\n";
#else
  if(p.zero()) {
    os << "<td>";
    os << otherbefore;
    os << "0";
    os << otherafter;
    os << "</td>";
  } else {
    bool started = false;
    int deg = p.tipMonomial().numberOfFactors();
    int nterms = p.numberOfTerms();
    PolynomialIterator w = p.begin();
    while(nterms>0) {
      const Term & t = *w;
      int curr = t.MonomialPart().numberOfFactors();
      while(deg>curr) {
        os << "<td>&nbsp;</td>";
        --deg;
      };
      os << "<td>";
      if(started) {
        os << otherbefore;
      } else {
        os << tipbefore;
      };
      started = true;
      if(t.CoefficientPart().sgn()>0) {
        os << "+";
      };
      os << t;
      if(started) {
        os << otherafter;
      } else {
        os << tipafter;
      };
      os << "</td>\n";
      --deg;--nterms;++w;
    };
  };
#endif
};

void PrintPoly(MyOstream & os,const Polynomial & p,int n) {
  PrintPoly(os,p,n,"","","","");
};

void PrintPoly(MyOstream & os,const Polynomial & p,int n,
  const char * colortip,const char * colorrest) {
  int len1 = strlen(colortip)+1;
  int len2 = strlen(colorrest)+1;
  char * one = new char[len1+strlen("<B><font color=\"\">")];
  char * two = new char[len2+strlen("<font color=\"\">")];
  strcpy(one,"<B><font color=\"");
  strcat(one,colortip);
  strcat(one,"\">");
  strcpy(two,"<font color=\"");
  strcat(two,colorrest);
  strcat(two,"\">");
  PrintPoly(os,p,n,one,"</font></B>",two,"</font>");
};

void PrintPoly(MyOstream & os,const Polynomial & p,int n,
  const char * colortip) {
  PrintPoly(os,p,n,colortip,colortip);
};
  

void PrintComputation(MyOstream & os,const vector<Polynomial> & L) {
  const char * bot = "red";
  const char * top = "purple";
  const char * qu = "blue";
  const char * re = "green";
  const topDim =  L[0].tipMonomial().numberOfFactors();
  const botDim =  L[1].tipMonomial().numberOfFactors();
  bool withexplain = true;
  os << tableString << '\n';
    // QUOTIENT ROW
  os << "<tr><td colspan=\"" << botDim+1 << "\">&nbsp;</td><td>&nbsp;</td>\n"; 
        // space for bot and space
  PrintPoly(os,L[2],topDim+1,qu);
        // Division Line
  os << "<tr><td colspan=\"" << botDim+1 << "\">&nbsp;</td><td>&nbsp;</td>\n"; 
        // space for bot and space
  os << "<td colspan=\"" << topDim+1 << "\"><hr></td>\n";
  os << "</tr>\n";
  os << "</tr>\n";
     // DIVISOR, DIVIDEND ROW
  os << "<tr>";
  PrintPoly(os,L[1],botDim+1,bot);
  os << "<td> | </td>\n";  //space
  PrintPoly(os,L[0],topDim+1,top); 
     // top
  os << "</tr>\n";
    // OTHER ROWS
  int sz = L.size();
  int i = 4;
  int dim;
  while(i<sz) { // LAST ITEM SAME AS THIRD SO OMIT ==sz
    dim = L[i].tipMonomial().numberOfFactors();
    os << "<tr>\n";
    if(i%2==1) {
      os << "<td colspan=\"" << botDim + topDim - dim + 2 << "\">&nbsp;</td>\n";
      os << "<td colspan=\"" << dim + 1 << "\"><hr></td>\n";
      os << "</tr><tr>\n";
    };
    os << "<td colspan=\"" << botDim + topDim - dim + 2 << "\">&nbsp;</td>\n";
    if(i==sz-1) {
      PrintPoly(os,L[i],dim+1,re);
    } else {
      PrintPoly(os,L[i],dim+1);
    };
    os << "</tr>\n";
    ++i;
  };
#if 0
  os << "<tr>\n";
  dim = L[3].tipMonomial().numberOfFactors();
  os << "<td colspan=\"" << botDim + topDim - dim + 1 << "\">&nbsp;</td>\n";
  os << "<td colspan=\"" << dim << "\">\n";
  PrintPoly(os,L[3]);
  os << "</td>\n";
  os << "</tr>\n";
#endif
  os << "</table>\n";
  if(withexplain) {
    os << "<br><br>\n";
    os << "That is:\n";
    os << "<font color=\"" << top << "\">" << L[0] << "</font>\n";
    os << "= (";
    os << "<font color=\"" << qu  << "\">" << L[2] << "</font>\n";
    os << ") (";
    os << "<font color=\"" << bot << "\">" << L[1] << "</font>\n";
    os << ") + (";
    os << "<font color=\"" << re << "\">" << L[3] << "</font>\n";
    os << ")\n";
  };
  bool doubleexplain = true;
  if(doubleexplain) {
    os << "<br><br>\n";
    os << "That is:<br>\n";

    os << tableString << "<tr><td>";

    os << tableString << "<tr><td>";
    os << "<font color=\"" << top << "\">" << L[0] << "</font>\n";
    os << "</td></tr><tr><td>\n";
    os << "<hr>";
    os << "</td></tr><tr><td>\n";
    os << "<font color=\"" << bot << "\">" << L[1] << "</font>\n";
    os << "</td></tr></table>\n";

    os << "</td><td>=</td><td>";
    os << "<font color=\"" << qu  << "\">" << L[2] << "</font>\n";
    os << "</td><td>+</td>";
    os << "</td><td>";

    os << tableString << "<tr><td>";
    os << "<font color=\"" << re << "\">" << L[3] << "</font>\n";
    os << "</td></tr><tr><td>\n";
    os << "<hr>";
    os << "</td></tr><tr><td>\n";
    os << "<font color=\"" << bot << "\">" << L[1] << "</font>\n";
    os << "</td></tr></table>\n";

    os << "</td></tr></table>\n";
  };
  os << "<br><br><hr>\n";
};

void LongDivision(const Variable & x,
   const Polynomial & dividend,const Polynomial & divisor,
   Polynomial & qoutient, Polynomial & remainder,MyOstream & os,
   PrintingEnvironment & env) {
#ifdef USEASCII
  os << "We are going to divide " 
     << env.nextline()
     << dividend 
     << env.nextline()
     << "by " 
     << env.nextline()
     << divisor 
     << env.newparagraph();
#endif
#define USEHTML
  qoutient.setToZero();
  remainder = dividend; 
  vector<Polynomial> display;
  display.push_back(dividend);  // 0
  display.push_back(divisor);   // 1
  display.push_back(qoutient);  // 2
  display.push_back(remainder); // 3
  PrintComputation(os,display);
  Term t;
  Monomial one;
  Polynomial temp,temp2;
  while(!remainder.zero() && 
        remainder.tipMonomial().numberOfFactors()>=
        divisor.tipMonomial().numberOfFactors()) {
    const Monomial & remTip = remainder.tipMonomial();
    const Monomial & divTip = divisor.tipMonomial();
    int n = remTip.numberOfFactors() - divTip.numberOfFactors();
    t.setToOne();
    if(n<0) break;
    while(n>0) {
      t.MonomialPart() *= x;
      --n;
    };
    t.Coefficient() *= remainder.tipCoefficient();
    t.Coefficient() /= divisor.tipCoefficient();
    temp = t; 
    qoutient += temp;
    display[2] += temp;
    temp2.doubleProduct(t.Coefficient(),t.MonomialPart(),divisor,one);
    remainder -= temp2;
    display[3] -= temp2;
    display.push_back(temp2);      // 3 + 2 n + 1
    display.push_back(display[3]); // index 3 + 2n + 2
    PrintComputation(os,display);
#ifdef USEASCII
    os << "We subtract " 
       << env.nextline()
       << t 
       << env.nextline()
       << "times the divisor "
       << env.nextline()
       << divisor 
       << env.nextline()
       << "(that is, we subtract " 
       << temp2 << ')'
       << env.nextline()
       << "to obtain "
       << env.nextline()
       << remainder 
       << env.newparagraph();
#endif
  };
#ifdef USEASCII
  os << "Final quotient: " << qoutient << '\n';
  os << "Final remainder: " << remainder << '\n';
#endif
};

void _LongDivision(Source & so,Sink & si) {
  Variable v;
  Polynomial top,bot,quot,rem;
  stringGB filename;
  bool b;
  so >> v >> top >> bot >> filename >> b;
  if(b) {
    tableString = "<table border>";
  } else {
    tableString = "<table>";
  };
  so.shouldBeEnd();
  si.noOutput();
  ofstream ofs(filename.value().chars());
  MyOstream os(ofs);
  os << "<html><body>\n";
  PrintingEnvironment env;
  LongDivision(v,top,bot,quot,rem,os,env);
  os << "</body></html>\n";
  ofs.close();
};

AddingCommand temp1LongDivision("LongDivision",5,_LongDivision);

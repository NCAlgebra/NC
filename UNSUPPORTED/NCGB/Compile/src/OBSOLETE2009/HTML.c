// Mark Stankus 1999 (c)
// HTML.cpp

#include "HTML.hpp"
#include "GBStream.hpp"
#include "Debug1.hpp"

HTML::~HTML(){};

HTMLTable::~HTMLTable() {};

HTMLTag::~HTMLTag() {};

HTMLColor::~HTMLColor() { delete d_color_p; };

HTMLVerbatim::~HTMLVerbatim(){ delete [] d_s; };

HTMLInteger::~HTMLInteger(){};

void HTMLTable::add(HTML* p,int row,int col) {
  vector<HTML*> emptyL;
  --row;
  --col;
  int nrows = d_entries.size();
  while(nrows<=row) {
    d_entries.push_back(emptyL);
    ++nrows;
  };
  nrows = d_entries.size();
  int active = 0;
  while(active<nrows) {
      int numadd = col - d_entries[active].size() + 1;
      if(numadd>0) {
        while(numadd) {
          d_entries[active].push_back((HTML *)0);
          --numadd;
        };
      };
      ++active;
  };
  if(d_entries[row][col]) {
    GBStream << "Tring to add too many entries to the "
             << "location in the " << row+1 << "th row "
             << "and " << col+1 << "th column.";
    GBStream << "Previously added:"; 
    d_entries[row][col]->print(GBStream);
    errorc(__LINE__); 
  } else d_entries[row][col] = p; 
};

void HTMLTag::print(MyOstream & os) const {
  os << d_begin;
  d_p->print(os);
  os << d_end;
};

void HTMLTable::print(MyOstream & os) const {
  typedef vector<HTML*>::const_iterator VCI;
  typedef vector<vector<HTML*> >::const_iterator VVCI;
  os << "<table " << (d_border ? "border" : "noborder") << ">";
  VVCI w1 = d_entries.begin(), e1 = d_entries.end();
  while(w1!=e1) {
    os << "<tr>\n";
    const vector<HTML*> & V = *w1;
    VCI w2 = V.begin(), e2 = V.end();
    while(w2!=e2) {
      os << "<td>\n";
      HTML * temp = *w2;
      if(temp) temp->print(os);
      os << "</td>\n";
      ++w2;
    };
    os << "</tr>\n";
    ++w1;
  };
  vector<vector<HTML*> > d_entries;
  os << "</table>";
};

void HTMLVerbatim::print(MyOstream & os) const {
  os << d_s;
};

void HTMLInteger::print(MyOstream & os) const {
  os << d_n;
};

void HTMLColor::print(MyOstream & os) const {
  os << "<font color=\"" << d_color_p << "\">\n";
  d_html_p->print(os);
  os << "</font>\n";
};

void HTML::errorh(int n) {
  DBGH(n);
};

void HTML::errorc(int n) {
  DBGC(n);
};

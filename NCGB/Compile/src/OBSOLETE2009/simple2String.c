// simpleString.c

#include "simple2String.hpp"
#include "charsless.hpp"
#include "RecordHere.hpp"
#include "Debug1.hpp"
#include "CompareNotOnHash.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include <limits.h>
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#include "MyOstream.hpp"
#include "vcpp.hpp"
        
extern vector<simpleString> * s_AllStrings_p;

set<pair<const char *,int>,CompareNotOnHash> * s_not_on_hash_table_and_recorded_p = 0;
set<pair<const char *,int>,CompareNotOnHash> * s_not_on_hash_table_not_recorded_p = 0;
map<const char *,int,charsless>              * s_on_hash_table_p = 0;
vector<const char *> * s_hash_vector_str_p = 0;
vector<int>    * s_hash_vector_len_p = 0;

bool s_record_string = true;
bool s_save_variables = false;

extern int hash(const unsigned char *);

// the file with filename s MUST have at least 1 line!!! 
// each line can contain at most 999 characters!!! 
void ReadInHashTable(map<const char *,int,charsless> & MAP,
       vector<const char *> & strs,vector<int> & lens,char * s) {
  strs.erase(strs.begin(),strs.end());
  lens.erase(lens.begin(),lens.end());
//  MAP.erase(MAP.begin(),MAP.end());
  list<char *> Lstr;
  list<int>  Llen;
  ifstream ifs(s);
  char word[1000];
  ifs.get(word,1000);
  ifs.ignore(INT_MAX,'\n');
  int len;
  char * ptr = 0;
  int i = 0;
  while(true) {
    ifs.get(word,1000);
    ifs.ignore(INT_MAX,'\n');
    cerr << "word is:" << word << '\n';
    cerr.flush();
    if(*word=='\0') break;
    len = strlen(word);
    RECORDNEW(ptr = new char[len+1];)
    strcpy(ptr,word);
    Lstr.push_back(ptr);
    Llen.push_back(len);
    pair<const char *,int> pr(ptr,i);
    MAP.insert(pr);
    ++i;
  };
  const int sz = Lstr.size();
  strs.reserve(sz);
  lens.reserve(sz);
  copy(Lstr.begin(),Lstr.end(),back_inserter(strs));
  copy(Llen.begin(),Llen.end(),back_inserter(lens));
};

void simpleString::assign(const char * x) {
  if(!x) DBG();
  if(!s_hash_vector_str_p) {
    RECORDNEWBEFORE;
    s_not_on_hash_table_and_recorded_p = 
        new set<pair<const char *,int>,CompareNotOnHash>;
    s_not_on_hash_table_not_recorded_p = 
           new set<pair<const char *,int>,CompareNotOnHash>; 
    s_on_hash_table_p = new map<const char *,int,charsless>;
    s_hash_vector_str_p = new vector<const char *>; 
    s_hash_vector_len_p = new vector<int>;
    RECORDNEWAFTER;
    ReadInHashTable(*s_on_hash_table_p,*s_hash_vector_str_p,
                    *s_hash_vector_len_p,"ncgb_hash.txt");
#if 0
    if(!s_AllStrings_p) {
      s_AllStrings_p = new vector<simpleString>;
      typedef vector<const char *>::const_iterator VI;
      VI w = s_hash_vector_str_p->begin(), e = s_hash_vector_str_p->end();
      simpleString SS;
      while(w!=e) {
        SS.assign(*w);
        s_AllStrings_p->push_back(SS);
      };
    };
#endif
  };
  int n = hash((const unsigned char *)x) - 1;
  if(n<0 || n>=(int)s_hash_vector_str_p->size()) {
    n = -1;
GBStream << " Missed the string " << x << " with the hash value " << n << ".\n";
  } else if(strcmp((*s_hash_vector_str_p)[n],x)==0) {
    // do nothing
  } else {
GBStream << " Missed the string " << x 
         << " via the hash.\n The hash value is "
         << n << " which is " << (*s_hash_vector_str_p)[n]
         << "\n";
    map<const char *,int,charsless>::iterator w = s_on_hash_table_p->find((char *)x);
    if(w!=s_on_hash_table_p->end()) {
      n = (*w).second;
      d_s   = (*s_hash_vector_str_p)[n];
      d_len = (*s_hash_vector_len_p)[n];
    } else n=-1;
  };
  if(n==-1) { 
    // NOT ON THE HASH TABLE
    d_len = strlen(x);
    pair<const char *,int> pr(x,d_len);
    set<pair<const char *,int>,CompareNotOnHash>::const_iterator ww;
#if 1
    ww = s_not_on_hash_table_and_recorded_p->find(pr);
#endif
    if(ww!=s_not_on_hash_table_and_recorded_p->end()) {
      // ON "SET AND RECORDED"
      d_s = (*ww).first;
      d_len = (*ww).second;
  if(!d_s) DBG();
    } else {
      // NOT ON "SET AND RECORDED"
      set<pair<const char *,int>,CompareNotOnHash>::iterator www;
#if 1
      www = s_not_on_hash_table_not_recorded_p->find(pr);
#endif
      if(www!=s_not_on_hash_table_not_recorded_p->end()) {
        // ON "SET NOT RECORDED"
        d_s = (*www).first;
        d_len = (*www).second;
  if(!d_s) DBG();
      } else {
        // NOT ON "SET NOT RECORDED"
        RECORDNEW(d_s = new char[pr.second+1];)
  if(!d_s) DBG();
        strcpy((char *)d_s,x);
        pair<const char * const,int> pr2(d_s,d_len);
        if(s_record_string) {
          // PUT ON "SET AND RECORDED"
          s_not_on_hash_table_and_recorded_p->insert(pr2);
#if 1
        } else {
          // PUT ON "SET NOT RECORDED"
          s_not_on_hash_table_not_recorded_p->insert(pr2);
#endif
        };
      };
    };
  }; 
GBStream << "simpleString::d_s is now:" << d_s << '\n';
};

bool simpleString::operator ==(const char * x) const {
  simpleString y(x);
  return operator==(y);
};

MyOstream & operator<<(MyOstream & os,const simpleString & x) {
  return os << x.d_s;
};

bool simpleString::operator<(const simpleString & x) const {
  return d_s < x.d_s;
};

char * simpleString::s_empty_string = "";

// (c) Mark Stankus 1999
// CharacterSource.hpp 

#ifndef INCLUDED_CHARACTERSOURCE_H 
#define INCLUDED_CHARACTERSOURCE_H 

#include "MyOstream.hpp"
#include "Debug1.hpp"
#include "simpleString.hpp"
#include "GBStream.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif

class  CharacterSource {
  CharacterSource(const CharacterSource &);
    // not implemented
  void operator=(const CharacterSource &);
    // not implemented
  static void errorh(int);
  static void errorc(int);
protected:
  bool check(char c,const char * ignore) {
    bool result = true;
    while(*ignore!='\0') {
      if(c==*ignore) {
        result = false;
        break;
      };
      ++ignore;
    };
    return result;
  };
  char * d_word;
  char * d_avoid;
  static char * s_avoid_nothing;
  char d_unget;
  bool d_useUnget;
  bool d_skipws;
public:
  CharacterSource()  : d_word(0), d_avoid(""), d_unget('$'), 
      d_useUnget(false), d_skipws(true) {};
  virtual ~CharacterSource();
  void skipws(bool flag) { d_skipws = flag;};
  bool skipws() const { return d_skipws;};
  virtual bool eof() const = 0;
  virtual void vGet(char & c) = 0;
  void passCharacter() {
    if(!d_useUnget) errorh(__LINE__);
    d_useUnget = false;
//GBStream << "passing " << d_unget << '\n';
  };
  void peekCharacter(char & c) {
    if(!d_useUnget) {
      if(eof()) errorh(__LINE__);
      vGet(d_unget);
      d_useUnget = true;
    };
    c = d_unget;
//GBStream << "peeking " << d_unget << '\n';
  };
  void getCharacter(char & c) {
    peekCharacter(c);
    passCharacter();
  };
  void unGetCharacter(char c) {
    if(d_useUnget) errorh(__LINE__);
    if(d_unget!=c) errorh(__LINE__);
    d_useUnget = true;
  };
  int getNumber() {
    int result = 0;
    int sign = 1;
    char c;
    peekCharacter(c);
    if(c=='-') {
      sign = -1;
      passCharacter();
      peekCharacter(c);
      if(c=='+') {
        passCharacter();
        peekCharacter(c);
      } else if(c=='-') {
        sign = 1;
        passCharacter();
        peekCharacter(c);
      };
    } else if(c=='+') {
      passCharacter();
      peekCharacter(c);
      if(c=='+') {
        passCharacter();
        peekCharacter(c);
      } else if(c=='-') {
        sign = -1;
        passCharacter();
        peekCharacter(c);
      };
    };
    if('0'<=c&&c<='9') {
      while('0'<=c && c<='9') {
        passCharacter();
        result *=10;
        result += (c-'0');
        if(eof()) break;
        peekCharacter(c);
      };
    } else {
      GBStream << "Error: no integer found";
      GBStream << "Last character peeked:" << c << '\n';
      errorh(__LINE__);
    };
    result *= sign;
    return result;
  };
  void peekCharacter(char & c,const char * ignore) {
    getCharacter(c);
    while(!check(c,ignore)) {
      getCharacter(c);
    };
    d_useUnget = true;
    d_unget = c;
  };
  void getCharacter(char & c,const char * ignore) {
    peekCharacter(c,ignore);
    d_useUnget = false;
  };
  simpleString getStringWithLength(int len) {
    bool save = d_skipws;
    d_skipws = false;
    if(!d_word) {
      d_word = new char[len+1];
    } else if(len>(int)strlen(d_word)) {
      delete d_word;
      d_word = new char[len+1];
    };
    char * t = d_word;
    while(len) { 
      getCharacter(*t);
      --len;++t;
    };
    *t = '\0';
    simpleString result(d_word);
    d_skipws = save;
    return result;
  }; 
  void passString() {
    char c;
    getCharacter(c);
    if(c!='\"') errorh(__LINE__);
    peekCharacter(c);
    while(c!='\"') {
      passCharacter();
      peekCharacter(c);
    };
    passCharacter();
  };
  simpleString getString(int & len,bool keep = true) {
    bool save = d_skipws;
    d_skipws = false;
    if(!d_word) {
      d_word = new char[1001];
    } else if(strlen(d_word)<1000) {
      delete d_word;
      d_word = new char[10001];
    };
    char * t = d_word;
    char c;
    getCharacter(c);
    if(c!='\"') errorh(__LINE__);
    if(keep) {
      *t=c;++t;++len;
    };
    peekCharacter(c);
    len  = 0;
    while(c!='\"') {
      passCharacter();
      *t = c;++t;++len;
      if(len>1000) errorh(__LINE__);
      peekCharacter(c);
    };
    if(keep) {
      *t=c;++t;++len;
    };
    passCharacter();
    *t = '\0';  
    simpleString result(d_word);
    d_skipws = save;
    return result;
  };
    // caller does not delete the string
    // result of call valid until the next call to one of the get*Word variants
  simpleString getWord(int & len) {
    len = 0;
    if(!d_word) {
      d_word = new char[1001];
    } else if(strlen(d_word)<1000) {
      delete d_word;
      d_word = new char[10001];
    };
    char * t = d_word;
    char c;
    peekCharacter(c);
    while(('a'<=c && c <= 'z') || ('A'<=c && c <= 'Z')) {
      passCharacter();
      *t = c; 
      ++t;++len;
      if(eof()) break;
      peekCharacter(c);
      if(len>1000) errorh(__LINE__);
    };
    *t = '\0';  
    simpleString result(d_word);
    return result;
  };
  simpleString getAlphaWord(int & len) {
    len = 0;
    if(!d_word) {
      d_word = new char[1001];
    } else if(strlen(d_word)<1000) {
      delete d_word;
      d_word = new char[1001];
    };
    char c;
    char * t = d_word;
    peekCharacter(c," \n");
    while(('a'<=c && c <= 'z') || ('A'<=c && c <= 'Z')) {
      passCharacter();
      *t = c; 
      ++t;++len;
      if(len>1000) errorh(__LINE__);
      if(eof()) break;
      peekCharacter(c);
    };
    *t = '\0';  
    simpleString result(d_word);
    return result;
  };
  simpleString getAlphaNumWord(int & len) {
    len = 0;
    if(!d_word) {
      d_word = new char[1001];
    } else if(strlen(d_word)<1000) {
      delete d_word;
      d_word = new char[1001];
    };
    char c;
    char * t = d_word;
    peekCharacter(c);
    if(('a'<=c && c <= 'z') || 
       ('A'<=c && c <= 'Z')) {
      while(('a'<=c && c <= 'z') || 
            ('A'<=c && c <= 'Z') || 
            ('0'<=c && c <= '9')) {
         passCharacter();
         *t = c; 
         ++t;++len;
         if(len>1000) errorh(__LINE__);
         if(eof()) break;
         peekCharacter(c);
      };
    };
    *t = '\0';  
    simpleString result(d_word);
    return result;
  };
  simpleString getUntilCharacterButNot(char avoid) {
    int len = 0;
    if(!d_word) {
      d_word = new char[1001];
    } else if(strlen(d_word)<1000) {
      delete d_word;
      d_word = new char[1001];
    };
    char * t = d_word;
    peekCharacter(*t);
 cout << "char:" << *t << endl;
    while(*t!=avoid) {
 cout << "char:" << *t << endl;
      passCharacter();
      ++t;++len;
      if(len>1000) errorh(__LINE__);
      peekCharacter(*t,"\n\t ");
    };
    *t = '\0';
    simpleString result(d_word);
    return result;
  };
  simpleString getUntilCharacterButNot(const char * avoids,int & len) {
    len = 0;
    if(!d_word) {
      d_word = new char[1001];
    } else if(strlen(d_word)<1000) {
      delete d_word;
      d_word = new char[10001];
    };
    char * t = d_word;
    peekCharacter(*t);
    while(check(*t,avoids)) {
      passCharacter();
      ++t;++len;
      if(len>1000) errorh(__LINE__);
      peekCharacter(*t);
    };
    *t = '\0';
    simpleString result(d_word);
    return result;
  };
  int grabInteger() {
    int result = 0;
    int sign = 1;
    char c;
    peekCharacter(c);
    if(c=='-') {
      passCharacter();
      sign = -1;
      peekCharacter(c);
    };
    if('0'<=c&&c<='9') {
      while('0'<=c && c<='9') {
        passCharacter();
        result *=10;
        result += (c-'0');
        if(eof()) break;
        peekCharacter(c);
      };
    } else {
      GBStream << "Error: no integer found\n.";
      errorh(__LINE__);
    };
    result *= sign;
    return result;
  };
  char * grabBracketed(char front,char back) {
    bool save = d_skipws;
    d_skipws = false;
    char c;
    getCharacter(c);
    if(c!=front) {
      GBStream << "Got:" << c << " and not " << front << '\n';
      errorh(__LINE__);
    };
    vector<char> vec;
    int nest = 1;
    while(nest>0)  {
      getCharacter(c);
      if(c==front) {
        ++nest;
      } else if(c==back) {
        --nest;
      };
      if(nest!=0) vec.push_back(c);
      if(nest<0) errorh(__LINE__);
    };
    if(c!=back) {
      GBStream << "Got:" << c << " and not " << front << '\n';
      errorh(__LINE__);
    };
    int sz = vec.size();
    char * result = new char[sz+1];
    copy(vec.begin(),vec.end(),result);
    result[sz] = '\0';
    d_skipws = save;
    return result;
  };
};
#endif

// Mark Stankus 1999 (c)
// TokenSource.c

#include "TokenSource.hpp"

bool TokenSource::peekToken() {
  bool result = true;
  if(!d_inreserve) {
    char c;
    d_so.peekCharacter(c," \n");
    if(c=='+') {
      d_type = PLUS;
      d_s = "+";
      d_n = -999;
    } else if(c=='/') {
      d_type = DIVIDE;
      d_s = "/";
      d_n = -999;
    } else if(c=='_') {
      d_type = PATTERN;
      d_s = "_";
      d_n = -999;
    } else if(c=='*') {
      d_so.passCharacter();
      d_so.peekCharacter(c," \n");
      if(c!='*') {
        GBStream << "Stars must appear in pairs.\n";
        DBG();
      };
      d_so.passCharacter();
      d_type = DOUBLESTAR;
      d_s = "**";
      d_n = -999;
    } else if('0'<=c && c<='9') {
      d_type = INTEGER;
      d_s = "invalid";
      int n = d_so.grabInteger();
    } else if(c='\"') {
      int dummy;
      d_type = STRING;
      d_s = getString(dummy);
      d_n = -999;
    } else if(c=='[') {
      d_type = LBRACKET;
      d_s = "[";
      d_n = -999;
    } else if(c==']') {
      d_type = RBRACKET;
      d_s = "]";
      d_n = -999;
    } else if(c=='{') {
      d_type = LCURLY;
      d_s = "[";
      d_n = -999;
    } else if(c=='}') {
      d_type = RCURLY;
      d_s = "]";
      d_n = -999;
    } else if(c==',') {
      d_type = COMMA;
      d_s = ",";
      d_n = -999;
    } else if(('a'<=c&&c<='z') ||('A'<=c&&c<='Z'))  {
      int dummy;
      d_type = SYMBOL;
      d_s = getAlphaNumWord(dummy);
      d_n = -999;
    } else {
      GBStream << "Encounted unexpected character " << c << '\n';
      GBStream << "The last token encounted has string " << d_s 
               << " and integer " << n 
               << " and was of type " << TYPENAME(d_type) << '\n';
      DBG();
    };
  };
};

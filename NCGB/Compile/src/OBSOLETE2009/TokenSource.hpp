// Mark Stankus 1999 (c)
// TokenSource.h

#ifndef INCLUDED_TOKENSOURCE_H
#define INCLUDED_TOKENSOURCE_H

class TokenSource {
  CharacterSource & d_so;
  bool d_inreserve;
  TYPES d_type;
  simpleString d_s;
  int d_n;
public:
  TokenSource(CharacterSouce & so) : d_so(so), d_inreserve(false),
     d_type(INVALID), d_s() {};
  ~TokenSource(){};
  typedef enum { INVALID,SYMBOL,STRING,INTEGER,PLUS,DIVIDE,DOUBLESTAR,
  LBRACKET,RBRRACKET,COMMA,LCURLY,RCURLY,PATTERN
  } TYPES;
  inline bool getToken(TYPES & type,simpleString & s,int & n);
  bool TokenSource::peekToken();
  inline void TokenSource::passToken();
  const char * TYPENAME(TYPES t) {
    if(t==INVALID) {
      return "INVALID";
    } else if(t==SYMBOL) {
      return "SYMBOL";
    } else if(t==STRING) {
      return "STRING";
    } else if(t==INTEGER) {
      return "INTEGER";
    } else if(t==PLUS) {
      return "PLUS";
    } else if(t==DIVIDE) {
      return "DIVIDE";
    } else if(t==DOUBLESTAR) {
      return "DOUBLESTAR";
    } else if(t==LBRACKET) {
      return "LBRACKET";
    } else if(t==RBRRACKET) {
      return "RBRACKET";
    } else if(t==COMMA) {
      return "COMMA";
    } else if(t==LCURLY) {
      return "LCURLY";
    } else if(t==RCURLY) {
      return "RCURLY";
    } else if(t==PATTERN) {
      return "PATTERN";
    };
    DBG();
    return (const char *) 0; // so that the compiler will not complain.
  };
};

inline bool TokenSource::getToken(TYPES & type,simpleString & s,int & n) {
  bool result = d_inreserve ? true : peekToken();
  if(result) {
    type = d_type;
    s = d_s;
    n = d_n;
    d_inreserve = false;
  };
  return result;
};

inline void TokenSource::passToken() {
  if(!d_inreserve) DBG(); 
  d_inreserve = false;
};

#endif

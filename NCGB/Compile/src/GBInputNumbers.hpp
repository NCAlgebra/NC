// GBInputNumbers.h

#ifndef INCLUDED_GBINPUTNUMBERS_H
#define INCLUDED_GBINPUTNUMBERS_H

struct GBInputNumbers {
  static int s_IOSYMBOL;
  static int s_IOSTRING;
  static int s_IOINTEGER;
  static int s_IOREAL;
  static int s_IOFUNCTION;
  static int s_IOINTARRAY;
  static int s_IOCOMMAND;
  static int s_IOEOI;
  static int s_IOEOF;
  static bool isSymbol(int n)   { return n==s_IOSYMBOL; };
  static bool isString(int n)   { return n==s_IOSTRING; };
  static bool isInteger(int n)  { return n==s_IOINTEGER;};
  static bool isFunction(int n) { return n==s_IOFUNCTION;};
  static bool isReal(int n)     { return n==s_IOREAL;};
  static bool isCommand(int n)  { return n==s_IOCOMMAND;};
};
bool isSymbol(int);
bool isString(int);
bool isInteger(int);
bool isFunction(int);
bool isReal(int);

inline bool isSymbol(int n)   { return n==GBInputNumbers::s_IOSYMBOL; };
inline bool isString(int n)   { return n==GBInputNumbers::s_IOSTRING; };
inline bool isInteger(int n)  { return n==GBInputNumbers::s_IOINTEGER;};
inline bool isFunction(int n) { return n==GBInputNumbers::s_IOFUNCTION;};
inline bool isReal(int n)     { return n==GBInputNumbers::s_IOREAL;};
inline bool isCommand(int n)  { return n==GBInputNumbers::s_IOCOMMAND;};
#endif

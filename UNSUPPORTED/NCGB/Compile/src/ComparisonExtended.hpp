// ComparisonExtended.h

#ifndef INCLUDED_COMPARISONEXTENDED_H
#define INCLUDED_COMPARISONEXTENDED_H

class MyOstream;

class ComparisonExtended {
  ComparisonExtended(); 
    // not implemented
public:
  static const ComparisonExtended s_LESS;
  static const ComparisonExtended s_EQUAL;
  static const ComparisonExtended s_EQUIVALENT;
  static const ComparisonExtended s_GREATER;
  static const ComparisonExtended s_INCOMPARABLE;
  ComparisonExtended(const ComparisonExtended & x)  : d_value(x.d_value) {} ; 
  void operator =(const ComparisonExtended & x) { d_value = x.d_value;}; 
  bool operator ==(const ComparisonExtended & x) const { return d_value == x.d_value;}; 
  ~ComparisonExtended() {};
  friend MyOstream & operator <<(MyOstream & os, const ComparisonExtended &);
private:
  explicit ComparisonExtended(int n) : d_value(n) {};
  int d_value;
};
#endif

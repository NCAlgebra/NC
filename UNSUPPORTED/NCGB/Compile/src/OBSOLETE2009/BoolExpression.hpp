// Mark Stankus 1999 (c)
// BoolExpression.hpp

#ifndef INCLUDED_BOOLEXPRESSION_H
#define INCLUDED_BOOLEXPRESSION_H

class BoolContext;

class BoolExpr {
  static void errorh(int);
  static void errorc(int);
public:
  enum LOGIC3 {TRUE, FALSE,UNKNOWN}; 
  BoolExpr() {};
  virtual ~BoolExpr() = 0;
  virtual ICopy<BoolExpr> evaluate(BoolContext &) = 0;
  virtual ICopy<BoolExpr> simplify() const = 0;
  virtual LOGIC3 value() const;
  virtual BoolExpr * clone() const = 0;
};

class AndExpr : public BoolExpr {
public:
  list<ICopy<BoolExpr> > d_list
  AndExpr() {};
  ~AndExpr();
  virtual ICopy<BoolExpr> evaluate(BoolContext &);
  virtual LOGIC3 value() const;
  virtual ICopy<BoolExpr> simplify() const;
  virtual BoolExpr * clone() const;
};

ICopy<BoolExpr> AndExpr::evaluate(BoolContext & x) {
  ICopy<BoolExpr> result(new AndExpr,Adopt::s_dummy);
  typedef list<ICopy<BoolExpr> >::const_iterator LI;
  LI w = d_list.begin(), e = d_list.end(); 
  ICopy<BoolExpr> temp; 
  while(w!=e) {
    temp = (*w)().evalutate(x);
    LOGIC3 x (temp().value());
    if(x==FALSE) {
      result = temp;
      break;
    } else if(x==UNKNOWN) {
      result.access().d_list.push_back(temp);
    };
    ++w;
  };
};

LOGIC3 AndExpr::value() const {
  if(d_list.empty()) {
    return TRUE;
  };
  return UNKNOWN;
};

ICopy<BoolExpr> AndExpr::simplify() const {
  BoolExpr * result = new AndExpr;
  typedef list<ICopy<BoolExpr> >::const_iterator LI;
  LI w = d_list.begin(), e = d_list.end();
  while(w!=e) {
    LOGIC3 x((*w)().value());
    if(x==FALSE) {
      delete result; 
      result = new OrExpr(); 
      break;
    } else if(x==UNKNOWN) {
      result->d_list.push_back(*w);
    };
    ++w;
  };
  ICopy<BoolExpr> out(result,Adopt::s_dummy);
  return out;
};

BoolExpr * AndExpr::clone() const {
  BoolExpr * result = new AndExpr();
  result->d_list = d_list;
};

class OrExpr : public BoolExpr {
public:
  list<ICopy<BoolExpr> > d_list
  OrExpr() {};
  ~OrExpr();
  virtual ICopy<BoolExpr> evaluate(BoolContext &);
  virtual LOGIC3 value() const;
  virtual ICopy<BoolExpr> simplify() const;
  virtual BoolExpr * clone() const;
};

ICopy<BoolExpr> OrExpr::evaluate(BoolContext & x) {
  ICopy<BoolExpr> result(new OrExpr,Adopt::s_dummy);
  typedef list<ICopy<BoolExpr> >::const_iterator LI;
  LI w = d_list.begin(), e = d_list.end(); 
  ICopy<BoolExpr> temp; 
  while(w!=e) {
    temp = (*w)().evalutate(x);
    LOGIC3 x (temp().value());
    if(x==TRUE) {
      result = temp;
      break;
    } else if(x==UNKNOWN) {
      result.access().d_list.push_back(temp);
    };
    ++w;
  };
};

LOGIC3 AndExpr::value() const {
  if(d_list.empty()) {
    return FALSE;
  };
  return UNKNOWN;
};

ICopy<BoolExpr> OrExpr::simplify() const {
  BoolExpr * result = new OrExpr;
  typedef list<ICopy<BoolExpr> >::const_iterator LI;
  LI w = d_list.begin(), e = d_list.end();
  while(w!=e) {
    LOGIC3 x((*w)().value());
    if(x==TRUE) {
      delete result; 
      result = new AndExpr(); 
      break;
    } else if(x==UNKNOWN) {
      result->d_list.push_back(*w);
    };
    ++w;
  };
  ICopy<BoolExpr> out(result,Adopt::s_dummy);
  return out;
};

BoolExpr * OrExpr::clone() const {
  BoolExpr * result = new OrExpr();
  result->d_list = d_list;
};

class NotExpr : public BoolExpr {
  ICopy<BoolExpr> d_x;
public:
  NotExpr(ICopy<BoolExpr> & x) : d_x(x) {};
  ~NotExpr();
  virtual ICopy<BoolExpr> evaluate(BoolContext &);
  virtual LOGIC3 value() const;
  virtual ICopy<BoolExpr> simplify() const;
  virtual BoolExpr * clone() const;
};

ICopy<BoolExpr> NotExpr::evaluate(BoolContext & x) {
  ICopy<BoolExpr> result,temp = d_x.evaluate(x);
  LOGIC3 val = temp().value();
  if(val==TRUE) {
    ICopy<BoolExpr> temp2(new OrExpr(),Adopt::s_dummy);
    result = temp2;
  } else if(val==FALSE) {
    ICopy<BoolExpr> temp3(new AndExpr(),Adopt::s_dummy);
    result = temp3;
  } else {
    ICopy<BoolExpr> temp4(new NotExpr(temp),Adopt::s_dummy);
    result = temp4;
  };
  return result;
};

LOGIC3 NotExpr::value() const {
  return UNKNOWN;
};

ICopy<BoolExpr> NotExpr::simplify() const {
  ICopy<BoolExpr> result,temp = d_x.simplify();
  LOGIC3 val = temp().value();
  if(val==TRUE) {
    ICopy<BoolExpr> temp2(new OrExpr(),Adopt::s_dummy);
    result = temp2;
  } else if(val==FALSE) {
    ICopy<BoolExpr> temp3(new AndExpr(),Adopt::s_dummy);
    result = temp3;
  } else {
    ICopy<BoolExpr> temp4(new NotExpr(temp),Adopt::s_dummy);
    result = temp4;
  };
  ICopy<BoolExpr> out(result,Adopt::s_dummy);
  return out;
};

BoolExpr * NotExpr::clone() const {
  return new NotExpr(d_x);
};

class ForAllExpr : public BoolExpr {
  list<BoolVariable> d_L;
  ICopy<BoolExpr> d_x;
public:
  ForAllExpr(list<BoolVariable> & L,ICopy<BoolExpr> & x) : 
     d_L(L), d_x(x) {};
  ~ForAllExpr();
  virtual ICopy<BoolExpr> evaluate(BoolContext &);
  virtual LOGIC3 value() const;
  virtual ICopy<BoolExpr> simplify() const;
  virtual BoolExpr * clone() const;
};

ICopy<BoolExpr> ForAllExpr::evaluate(BoolContext & x) {
  errorh(__LINE__);
};

LOGIC3 ForAllExpr::value() const {
  return UNKNOWN;
};

ICopy<BoolExpr> ForAllExpr::simplify() const {
  errorh(__LINE__);
};

BoolExpr * ForAllExpr::clone() const {
  return new ForAllExpr(d_L,d_x);
};

class ThereExistsExpr : public BoolExpr {
  list<BoolVariable> d_L;
  ICopy<BoolExpr> d_x;
public:
  ThereExistsExpr(list<BoolVariable> & L,ICopy<BoolExpr> & x) : 
     d_L(L), d_x(x) {};
  ~ThereExistsExpr();
  virtual ICopy<BoolExpr> evaluate(BoolContext &);
  virtual LOGIC3 value() const;
  virtual ICopy<BoolExpr> simplify() const;
  virtual BoolExpr * clone() const;
};

ICopy<BoolExpr> ThereExistsExpr::evaluate(BoolContext & x) {
  errorh(__LINE__);
};

LOGIC3 ThereExistsExpr::value() const {
  return UNKNOWN;
};

ICopy<BoolExpr> ThereExistsExpr::simplify() const {
  errorh(__LINE__);
};

BoolExpr * ThereExistsExpr::clone() const {
  return new ThereExistsExpr(d_L,d_x);
};
class BoolExpression {
  ICopy<BoolExpr> d_expr;
public:
  void and_with(const BoolExpression & x);
  void or_with(const BoolExpression & x);
  void not();
  void equal(AlgebraicExpression,AlgebraicExpression);
};
  
BoolExpr::~BoolExpr() {};
AndExpr::~AndExpr() {};
OrExpr::~OrExpr() {};
NotExpr::~OrExpr() {};
ForAllExpr::~OrExpr() {};
ThereExistsExpr::~OrExpr() {};

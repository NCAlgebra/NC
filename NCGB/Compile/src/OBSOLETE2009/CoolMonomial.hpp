

class CoolMonomial {
  Copy<list<Variable> > d_L;
  list<Variable>:;iterator d_beg;
  list<Variable>:;iterator d_end;
  int d_len;
public:
  CoolMonomial() : d_beg(d_L.access().begin()),  
        d_end(d_L.access().end()), d_len(0) {};
  CoolMonomial(const CoolMonomial & x) : d_L(x.d_L),
     d_beg(x.d_beg), d_end(x.d_end), d_len(x.d_len) {};
  ~CoolMonomial(){};
  void reserve(int){};
  void makeAlone() {
    if(d_L.alone()) {
      d_L.erase(d_L.access().begin(),d_beg);
      d_L.erase(d_end,d_L.access().end());
    } else {
      list<Variable> L;
      d_L = L;
      copy(d_beg,d_end,back_inserter(d_L.mustBeAlone()));
    };
  };
  void operator *=(const Variable & v) {
    makeAlone();
    d_L.mustBeAlone().push_back(v);
    ++d_len;
    d_beg = d_L.begin();
    d_end = d_L.end();
  };
    void variablesIn(VariableSet &) const;
  void setToOne() {
    d_len=0;
    list<Variable> L;
    d_L = L;
    d_beg = d_L.mustBeAlone().begin();
    d_end = d_L.mustBeAlone().end();
  };
  bool one() const { return d_beg==d_end;};
  int numberofFactors() const { return d_len;};
  void setPart(CoolMonomial & m,int start,int end) const {
    m=(*this);
    m.d_len = end-start;
    while(start) {
      ++m.d_beg;
      --start;
    };
  };
  void operator *=(const Monomial & x) const {
    CoolMonomial y(x);
    makeAlone();
    copy(y.beg,y.end,back_inserter(d_L.access()));
    d_len += y.d_len;
  };
  void premultiply(const CoolMonomial & x) {
    CoolMonomial y(x);
    CoolMonomial z(*this);
    operator=(y);
    operator*=(z);
  }; 
  void postmultiply(const Monomial & post) {
    operator *=(post);
  };
  void prepostmultiply(const Monomial & pre,const Monomial & post) {
    CoolMonomial y(pre);
    CoolMonomial z(*this);
    CoolMonomial w(post);
    operator=(y);
    operator*=(z);
    operator*=(w);
  }; 
  void copyFirst(const Monomial & x,int n) {
  };
  void copyLast(const Monomial & x,int n) {
  };
  bool operator!=(const Monomial & x) const {
    return !operator==(x);
  };
  MonomialIterator begin() const { return d_beg;};
  MonomialIterator end() const { return d_end;};
};

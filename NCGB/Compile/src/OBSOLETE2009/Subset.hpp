template<class C,class Iter>
class Subset {
  vector<int> d_subset;
  vector<int>::const_iterator d_iter_s;
  vector<int>::const_iterator d_end_s;
  C d_cont;
  Iter d_iter; 
  int d_n;
public:
  Subset(C1 & cont1,C2 & cont2) : 
     d_cont1(cont1), d_cont2(cont2) {};
  void begin() { 
    d_iter_s = d_subset.begin(); 
    d_end_s = d_subset.end(); 
    d_iter = d_cont.begin(); 
    d_n = 0;
    if(d_iter_s!=d_end_s) {
      int n = *d_iter_s;
      advance(d_iter,n);
      d_n = n;
    };
  };
  void end() { 
    d_iter_s = d_end_s; 
    d_n = d_cont1.size();
  };
  C operator *() const {
    return *d_iter;
  };
  void operator++() { advance(1);};
  void operator--() { advance(-1);};
  void advance(int m) {
    d_iter_s += m;
    if(d_iter_s!=d_end_s) {
      int n = *d_iter_s;
      int diff = n - d_n;
      advance(d_iter,diff);
  };
  void addNumber(int m) const {
    (void) AddToSortedContainer(d_subset,m);
  };
  const vector<int> & subset() const { return d_subset;};
  vector<int> & subset() { return d_subset;};
};

// Mark Stankus 1999 (c)
// mat.c

mat add(const mat & m1,const mat & m2) {
  int R = m1.rows();
  int C = m1.cols();
  if(R!=m2.rows()) DBG();
  if(C!=m2.cols()) DBG();
  mat result(m1);
  for(int i=1;i<=R;++i) {
    for(int j=1;j<=C;++j) {
      result.entry(i,j) += m2.entry(i,j);
    };
  };
  return result;
};

mat subtract(const mat & m1,const mat & m2) {
  int R = m1.rows();
  int C = m1.cols();
  if(R!=m2.rows()) DBG();
  if(C!=m2.cols()) DBG();
  mat result(m1);
  for(int i=1;i<=R;++i) {
    for(int j=1;j<=C;++j) {
      result.entry(i,j) -= m2.entry(i,j);
    };
  };
  return result;
};

mat times(const mat & m1,const mat & m2) {
  int R = m1.rows();
  int C = m2.cols();
  int M = m1.cols();
  if(M!=m2.rows()) DBG();
  mat result(R,C);
  Polynomial temp;
  for(int i=1;i<=r;++i) {
    for(int j=1;j<=c;++j) {
      for(int k=1;k<=C;++k) {
        temp = m1.entry(i,k);
        temp *= m2.entry(k,j);
        result.entry(i,j) += temp;
      };
    };
  };
  return result;
};

template<class T>
void DrowRow(int i,list<list<T> > & x) {
  list<list<T> >::iterator w = x.begin(), e = x.end();
  if(i<0) DBG();
  while(i && w!=e) { ++w;--i;}
  if(i!=0) DBG();
  x.erase(w);
};

template<class T>
void DrowColumn(int i,list<list<T> > & x) {
  list<list<T> >::iterator w = x.begin(), e = x.end();
  int j;
  while(w!=e) { 
    j = i;
    list<T> & L = *w;
    list<T>::iterator ww = L.begin(), ee = L.end();
    while(j && ww!=ee) { ++w;--j;}
      if(j!=0) DBG();
      L.erase(ww);
    };
    ++w;
  };
};

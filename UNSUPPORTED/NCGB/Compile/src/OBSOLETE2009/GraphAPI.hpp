
template<class T>
void GetGraphChildren(T *parent,vector<T*> & children);

template<class T>
HTML * HTMLGraphNode(T* node);

template<class T>
vector<HTML *> HTMLGraph(T * parent) {
  vector<HTML*> result;
  bool border = true;
  typedef vector<T*> VEC;
  VEC V;
  parent->GetGraphChildren(V);
  VEC::const_iterator w = V.begin(), e = V.end();
  HTML * child;
  HTML * aroot;
  while(w!=e) {
    child = *w;
    table = new HTMLTable(border);
    result.push_back(table); 
    table->add(p->HTMLGraphNode(),1,1);
    vector<HTML *> L;
    child->GetGraphChildren(L);
    vector<HTML*>::const_iterator ww = L.begin(), ee = L.end();
    if(ww!=ee) {
      HTMLTable * subtable = new HTMLTable(border);
      table->add(subtable,1,2);
      int i=1;
      while(ww!=ee) {
        subtable->add(*ww,1,i);
        ++ww;++i;
      };
    };
    ++w;
  };
};

template<class T>
vector<HTML *> HTMLShallowGraph(T * parent) {
  vector<HTML*> result;
  bool border = true;
  typedef vector<T*> VEC;
  VEC V;
  parent->GetGraphChildren(V);
  VEC::const_iterator w = V.begin(), e = V.end();
  HTML * child;
  HTML * aroot;
  while(w!=e) {
    child = *w;
    table = new HTMLTable(border);
    result.push_back(table); 
    table->add(HTMLGraphNode(p),1,1);
    ++w;
  };
};

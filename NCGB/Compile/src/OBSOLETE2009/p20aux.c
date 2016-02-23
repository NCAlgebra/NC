void _SetWreathOrder(Source & so,Sink & si) {
  stringGB name;
  list<stringGB> L;
  so >> name;
  GBInputSpecial(L,so);
  T * p = Name2Instance<AdmissibleOrder>::s_find(name);
  if(!p) {
    vector<vector<Variable> > VARS;
    vector<AdmissibleOrder *> ORDS;
    typedef list<stringGB>::const_iterator LI;
    LI w = L.begin(), e = L.end();
    AdmissibleOrder * q;
    while(w!=e) {
      q = Name2Instance<AdmissibleOrder>::s_find((*w).value());
      ORDS.push_back(q);
      ++w;
    };
    DBG();
    p = new WreathOrder(VARS,ORDS);
    Name2Instance<AdmissibleOrder>::s_add(name,p);
  };
  GBInput(*p,so);
  so.shouldBeEnd();
  si.noOutput();
};

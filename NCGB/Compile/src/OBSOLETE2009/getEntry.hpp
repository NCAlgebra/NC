
void getEntry(SymbolTable & ST,SymbolTableType & type,
              char *s,vector<AdmissibleOrder *> * vec) {
  if(!ST.isSymbol(s)) DBG();
  if(ST.type(s)!=type) DBG();
  vec = (vector<AdmissibleOrder *> *) ST.pointer(s);
};

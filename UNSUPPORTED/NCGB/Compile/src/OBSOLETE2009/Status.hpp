class Status {
  bool d_acceptor_has_children;
  bool d_giver_has_children;
  bool d_acceptor_has_rule;
  bool d_giver_has_rule;
  typedef bool (*)(SGSGNode *,SFSGNode *,int,int,const Status &) FUNC;
  bool process(SGSGNode * acceptor,SFSGNode * giver,int acceptorcount,
      ,int givercount,const Status &) {
    int count = 0;
    if((d_acceptor_has_children = acceptor->hasChildren())) {
      count = 1;
    };
    if((d_giver_has_children = giver->hasChildren())) {
      count += 2;
    };
    if((d_acceptor_has_rule = acceptor->hasRule(acceptorcount))) {
      count += 4;
    };
    if((d_giver_has_rule = giver->hasRule(givercount))) {
      count += 8;
    };
    switch(count) {
        // the error cases
      case  0:
      case  1:
      case  2:
      case  4: 
      case  8: 
      case 10: 
               DBG();
               break;
        // now the reduction cases 
      case 3:
      case 5:
      case 7:
      case 9:
      case 11:
      case 13:
      case 15:
               reduce();
               break;
        // one item only cases
      case 12: adoptnext();
               break;
      case  6: overlapadoptallreset();
               break;
      case 14: overlapadoptnext();     
               break;
      default: DBG();
    };
  };
};

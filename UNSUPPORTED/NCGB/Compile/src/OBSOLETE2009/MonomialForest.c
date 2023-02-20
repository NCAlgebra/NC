// Mark Stankus 1999 (c)
// MonomialForest.c

#include "MonomialForest.hpp"
#include "PrintStyle.hpp"

void MonomialForest::PrintAllTrees(MyOstream & os) const {
  PrintAllTrees(os,HTML,false);
};

void MonomialForest::PrintAllTrees(MyOstream & os,PrintStyle style) const {
  PrintAllTrees(os,style,false);
};

void MonomialForest::PrintAllTrees(MyOstream & os,PrintStyle style,
      bool extrafile) const {
  if(style==HTML || style==HTMLFULL) {
    extrafile = false;
    if(extrafile) {
      ++d_htmlnumberfiles;
      os.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles);
   };
   MAP::const_iterator w = d_tree_map.begin(), e = d_tree_map.end();
   while(w!=e) {
     os << "<br><hr>\n";
     (*w).second->print(os,style);
     ++w;
   };
 } else {
     os << "----------------- START ALL (" << d_tree_map.size() 
        << ")TREES ---------------\n";
     MAP::const_iterator w = d_tree_map.begin();
     MAP::const_iterator e = d_tree_map.end();
     while(w!=e) {
       os << "----------------- START ALL TREE " 
          << (*w).second->data() 
          << " ---------------\n";
       (*w).second->print(os);
       os << "\nwhich is: \n";
       (*w).second->print(os,FULL);
       os << "----------------- END ALL TREE " 
          << (*w).second->data() 
          << " ---------------\n";
       ++w;
     };
     os << "----------------- END ALL (" << d_tree_map.size() 
        << ")TREES ---------------\n";
  };
};

void MonomialForest::PrintTheSet(MyOstream & os) const {
  PrintTheSet(os,HTML,true);
};

void MonomialForest::PrintTheSet(MyOstream & os,PrintStyle style) const {
  PrintTheSet(os,style,true);
};

void MonomialForest::PrintTheSet(MyOstream & os,PrintStyle style,
          bool extrafile) const {
  if(style==HTML) { 
    extrafile = false;
    if(extrafile) {
      ++d_htmlnumberfiles;
      os.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles); 
    };
    typedef multiset<TheRule*,SFSGNode *,TheRuleCompare>::const_iterator SI;
    os << "<table border=\"4\">\n";
    SI wwww = d_set.begin(), eeee = d_set.end();
    os << "<tr><td>\n";
    os << "\nList of rules(" << d_set.size() << "):\n";
    os << "</td></tr>\n";
    while(wwww!=eeee) {
      os << "<tr><td>\n";
      (*wwww)->print(os,HTML);
      os << "</td></tr>\n";
      ++wwww;
    };
    os << "</table>\n";
  } else {
    os << "----------------- START SET ---------------\n";
    typedef multiset<TheRule*,SFSGNode *,TheRuleCompare>::const_iterator SI;
    SI wwww = d_set.begin(), eeee = d_set.end();
    os << "\nList of rules(" << d_set.size() << "):\n";
    while(wwww!=eeee) {
      (*wwww)->print(GBStream);
      os << '\n';
      ++wwww;
    };
    os << "----------------- END SET ---------------\n";
  };
};


void MonomialForest::errorh(int n) { DBGH(n); };

void MonomialForest::errorc(int n) { DBGC(n); };

void fillForCycles(SFSGNode * p,set<int> S) {
  if(S.find(p->number())!=S.end()) {
    GBStream << "We have a cycle!!\n";
    GBStream.flush();
    DBG(); 
  };
  S.insert(p->number());
  GBStream << "Adding  to set " << p->number() << '\n';
  p->print(GBStream);
  typedef vector<SFSGNode*>::const_iterator VI;
  VI w = p->forward().begin(), e = p->forward().end();
  GBStream << "List with length " << p->forward().size() << '\n';
  GBStream.flush();
  while(w!=e) {
    GBStream << "Loop1\n";
    (*w)->print(GBStream);
    GBStream << "Loop2\n";
    GBStream.flush();
    GBStream << "Loop3\n";
    GBStream << "In : " << (*w)->number() << '\n';
    GBStream << "Loop4\n";
    GBStream.flush();
    GBStream << "Loop5\n";
    fillForCycles(*w,S);
    GBStream << "Loop6\n";
    GBStream.flush();
    GBStream << "Loop7\n";
    GBStream << "Out : " << (*w)->number() << '\n';
    GBStream << "Loop8\n";
    GBStream.flush();
    GBStream << "Loop9\n";
    ++w;
  };
};

void MonomialForest::lookForCycles() const {
  MAP::const_iterator w = d_tree_map.begin(), e = d_tree_map.end();
  while(w!=e) {
    (*w).second->print(GBStream,HTML);
    set<int> S;
    GBStream << "FOO:lookforcycles\n";
    (*w).second->print(GBStream);
    GBStream.flush();
    (*w).second->print(GBStream,HTML);
    GBStream.flush();
    GBStream << "FOO:lookforcycles2\n";
    GBStream.flush();
    (*w).second->print(GBStream,HTML);
    GBStream.flush();
    fillForCycles((*w).second,S); 
    GBStream.flush();
    ++w;
  };
};

MonomialForest * s_forest_p = 0;
extern void _NCGBQuit();

void printForest() {
  GBStream << "Ackkk\n";
  s_forest_p->PrintAllTrees(GBStream,FULL);
  GBStream << "Ackkk\n";
  _NCGBQuit();
};

void MonomialForest::myprint(MyOstream & os,const list<SFSGNode*> & L) const {
  GBStream << "((" << L.size() << " elements.\n";
  list<SFSGNode*>::const_iterator w = L.begin(), e = L.end();
  while(w!=e) {
    SFSGNode * p = *w;
    if(p) {
      os << '(' << p->number() << ' ' << p->data() << ')';
    } else {
     os << "0 node?\n";
    };
    ++w;
    if(w!=e) os << "**";
  };
};

  // Does the set contain the give monomial as a tip of a polynomial?
MonomialForest::SET::iterator MonomialForest::setfind(const Monomial &m) {
  SET::iterator result = d_set.end();
  SET::iterator w = d_set.begin();
  while(w!=result) {
    if((*w)->d_m==m) {
      result = w;
      break;
    };
    ++w;
  };
  return result;
};

MonomialForest::SET::iterator MonomialForest::addPolynomialPrivate(
         const Polynomial & p) {
#ifdef DEBUG_MONOMIALFOREST
  ++d_htmlnumberfiles;
  GBStream.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles);
  GBStream << "Adding " << p << '\n';
  PrintAllTrees(GBStream);
#endif
  Polynomial q(p);
  q.makeMonic();
  Monomial m(q.tipMonomial());
  SET::iterator result = d_set.end();
  if(m.one()) {
    d_contraction_found = true;
  } else {
    q.Removetip();
    result = setfind(m);
    if(result==d_set.end()) {
#ifdef DEBUG_MONOMIALFOREST
      GBStream << "Adding new tip\n";
#endif
        // Create the rule
      TheRule * rule = new TheRule(m);
      result = d_set.insert(rule).first;
      rule->addRest(q);
        // Find the end of the path to put it on
      SFSGNode * ptr = 0;
      ForceTree(*m.begin(),ptr);
      ptr = ptr->find_force_forward(m);
        // Connect the rule to the end of the path.
      ptr->assignRule(rule);
    } else {
#ifdef DEBUG_MONOMIALFOREST
      GBStream << "Adding to existing tip\n";
#endif
        // add extra "rest" to the current information
        // a "quick" reduction will take care of this later.
      (*result)->addRest(q);
    };
  };
#ifdef DEBUG_MONOMIALFOREST
  GBStream << "AFTER Adding " << p << '\n';
  PrintAllTrees(GBStream);
#endif
  return result;
};

void MonomialForest::dump(
   const list<SFSGNode *> & acceptorpassed,
   const list<SFSGNode *> & giverpassed,
   const SET::iterator & w,const SET::iterator & e,SFSGNode * childacceptor,
   SFSGNode * childgiver,const  MonomialIterator & monw,int monsz,
   int count) const {
   ++d_htmlnumberfiles;
   GBStream.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles);
#ifdef DEBUG_MONOMIALFOREST
   GBStream << "acceptorpassed:";
   myprint(GBStream,acceptorpassed);
   GBStream << "<br>" << '\n';
   GBStream << "giverpassed:";
   myprint(GBStream,giverpassed);
   GBStream << "<br>" << '\n';
   GBStream << "(*w)->d_m:" << (*w)->d_m << "<br>" << '\n';
   GBStream << "*monw:" << *monw << "<br>" << '\n';
   GBStream << "monsz:" << monsz << "<br>" << '\n';
   GBStream << "count:" << count << "<br>" << '\n';
   GBStream << "d_acceptor_has_children:"
            << d_acceptor_has_children << "<br>" << '\n';
   GBStream << "d_giver_has_children:"
            << d_giver_has_children << "<br>" << '\n';
   GBStream << "d_acceptor_has_rule:" << d_acceptor_has_rule
            << "<br>" << '\n';
   GBStream << "d_giver_has_rule:" << d_giver_has_rule
            << "<br>" << '\n';
   PrintTheSet(GBStream);
   PrintAllTrees(GBStream);
   lookForCycles();
#endif
};

bool MonomialForest::process(MyOstream & os,
         list<SFSGNode *> & acceptorpassed,
         list<SFSGNode *> & giverpassed,
         SET::iterator & w,SET::iterator & e,
         SFSGNode * childacceptor,SFSGNode * childgiver,
         MonomialIterator monw,int monsz) {
  ++d_htmlnumberfiles;
  os.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles);
  SFSGNode * temp = 0;
  bool todo = true;
  bool performedreduction = false;
  int count = 0;
  Variable v(*monw);
  while(todo) {
    acceptorpassed.push_back(childacceptor);
    giverpassed.push_back(childgiver);
    todo = false;
    count = 0;
    if((d_acceptor_has_children = childacceptor->hasChildren())) {
      count += 8;
    };
    if((d_giver_has_children = childgiver->hasChildren())) {
      count += 4;
    };
    if((d_acceptor_has_rule = 
        childacceptor->hasRule(acceptorpassed.size()))) {
      count += 2;
    };
    if((d_giver_has_rule = 
        childgiver->hasRule(giverpassed.size()))) {
      count += 1;
    };
    dump(acceptorpassed,giverpassed,w,e,childacceptor,childgiver,
         monw,monsz,count);
    switch(count) {
        // the error cases
      case  0:
      case  1:
      case  2:
      case  4: 
      case  8: 
      case 10: 
               errorh(__LINE__);
               break;
        // now the reduction cases 
      case 3:
      case 5:
      case 7:
      case 9:
      case 11:
      case 13:
      case 15:
               performedreduction = true;
               reduceIt(childacceptor,childgiver,monw,
                        acceptorpassed,giverpassed,
                        monsz,w,e);
               break;
        // one item only cases
      case 12: //adopt next
#ifdef DEBUG_MONOMIALFOREST
               GBStream << "on 12\n";
#endif
               childacceptor->adoptAllChildrenOf(childgiver);
               ++monw;--monsz;
               v = *monw;
               childacceptor = childacceptor->find_forward_error(v);
               if(childgiver->hasChild(v,temp)) {
                 childgiver = temp;
                 todo = true;
               }; 
               break;
      case  6: //overlap adopt;
               // childacceptor->noChildrenAdoptAllChildrenOf(childgiver);
               break;
      case 14: // overlap adopt next     
               childacceptor->adoptAllChildrenOf(childgiver);
               ++monw;--monsz;
               if(monsz==0) break;
      dump(acceptorpassed,giverpassed,w,e,childacceptor,childgiver,
           monw,monsz,count);
               v = *monw;
               GBStream << "v is " << v << '\n';
               childacceptor = childacceptor->find_forward_error(v);
               if(childgiver->hasChild(v,temp)) {
                 childgiver = temp;
                 todo = true;
#ifdef DEBUG_MONOMIALFOREST
                 GBStream << "on 14\n";
#endif
               }; 
               break;
      default: errorh(__LINE__);
    };
  };
  return performedreduction;
};

bool MonomialForest::fixRule(TheRule * rule,SET::iterator & w,
      SET::iterator & e) {
  ++d_htmlnumberfiles;
  GBStream.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles);
  typedef list<Polynomial>::iterator LI;
  LI ww = rule->rests().begin(), ee = rule->rests().end();
#ifdef DEBUG_SFSGNODE
  GBStream << "Rule with tip:" << rule->d_m << '\n';
  rule->print(GBStream,SIMPLE);
  GBStream << '\n';
#endif
  if(ww==ee) {
    GBStream << "Empty list of rules unexpected!!!\n";
    errorh(__LINE__);
  };
  LI next = ww;++next; 
  bool reductionsPerformed = false;
  if(next!=ee) {
      // There is MORE THAN ONE element in the list!
      // subtract the first from the rest
    GBStream << "Multiple rules\n";
    const Polynomial & poly = *ww;
    LI save = next;
    while(next!=ee) {
      Polynomial & pp = *next;
      pp -= poly; 
      if(!pp.zero()) {
        reductionsPerformed = true;
        addPolynomialPrivate(pp);
      }
      ++next; 
      break;
    };
    GBStream << "Erasing due to multiple rules\n";
    rule->rests().erase(save,ee);
    rule->print(GBStream);
  };
  if(!reductionsPerformed) {
    // There is EXACTLY ONE element in the list and nothing new lower!
    MonomialIterator monw = rule->d_m.begin();
    int monsz = rule->d_m.numberOfFactors();
    if(monsz==0) {
      d_contraction_found = true;
    } else if(monsz>1) {
      list<SFSGNode*> acceptorpassed,giverpassed;
      Variable v(*monw); // first variable of the tip
      GBStream << "walking:v is " << v << '\n';
      SFSGNode * childacceptor = 0;
      SFSGNode * childgiver  = 0;
      if(!FindTree(v,childacceptor)) errorh(__LINE__);
        // if the tip consists of a single variable, then done processing
        // Start adjusting on the second variable.
      acceptorpassed.push_back(childacceptor);
      if(monsz>1) {
        ++monw;--monsz;
        while(monsz&&!reductionsPerformed) {
          v = *monw; // the nth variable of the tip for some $n\ge 2$
          childacceptor = childacceptor->find_forward_error(v);
#ifdef DEBUG_SFSGNODE
          GBStream << "walking2:v is " << v << '\n';
          GBStream << "childacceptor:";
          childacceptor->print(GBStream,FULL);
#endif
          if(FindTree(v,childgiver)) {
#ifdef DEBUG_SFSGNODE
            GBStream << "Have a root with label " << v << '\n';
#endif
            reductionsPerformed = process(GBStream,
                 acceptorpassed,giverpassed,w,e,
                 childacceptor,childgiver,monw,monsz);
          } else {
#ifdef DEBUG_SFSGNODE
            GBStream << "Do not have a root with label " << v << '\n';
#endif
           };
          acceptorpassed.push_back(childacceptor);
          acceptorpassed.push_back(childgiver);
          ++monw;--monsz;
        }; // while(monsz&&!reductionsPerformed)
      }; // if(monsz)
    };
  }; // if(!reductionsPerformed) 
  if(reductionsPerformed) {
    GBStream << "Resetting to front\n";
    w = d_set.begin(), e =d_set.end();
  } else {
    GBStream << "Incremeting\n";
    ++w;
  };  
  return reductionsPerformed;
};

void MonomialForest::fixTree() {
  ++d_htmlnumberfiles;
  GBStream.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles);
  SET::iterator w = d_set.begin(), e =d_set.end();
  while(w!=e) {
    TheRule * rule = *w;
#ifdef DEBUG_SFSGNODE
    if(fixRule(rule,w,e)) {
      GBStream << "Reduction occurred\n";
    } else {
      GBStream << "Done with tip\n";
    };
#else
    (void) fixRule(rule,w,e);
#endif
  }; // while(w!=e) 
};

void MonomialForest::removeRule(SET::iterator w) {
  ++d_htmlnumberfiles;
   GBStream.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles);
#if 1
   TheRule * p = *w;
   const Monomial & m = p->d_m;
   int monsz = m.numberOfFactors();
   MonomialIterator monw(m.begin());
   Variable v(*monw);
   SFSGNode * node = 0;
   if(!FindTree(v,node)) errorh(__LINE__);
   GBStream << "v is " << v << '\n';
   int searchlength = node->FirstWithMoreThanOneParent(monw,monsz);
   GBStream << "searchlength is " << searchlength << '\n';
   bool removetree = node->NodeGivesPathToLeaf();
   GBStream << "removetree is " << removetree << '\n';
   SFSGNode * prevnode = 0;
   while(!node->NodeGivesPathToLeaf()&&searchlength) {
     if(node->hasRule(p)) node->forgetRule(p);
     ++monw;--searchlength;
     v = *monw;
     GBStream << "v is " << v << '\n';
     GBStream << "searchlength is " << searchlength << '\n';
     prevnode = node;
     node = node->find_forward_error(v);  
     node->print(GBStream);
   };
   if(prevnode&&searchlength) {
     prevnode->forgetChild(v);
   };
   SFSGNode * nextnode = 0;
   while(node&&searchlength) {
     if(node->hasRule(p)) node->forgetRule(p);
     if(node->hasChildren()) {
       if(!node->hasOneChild()) errorh(__LINE__); 
       nextnode = * node->forward().begin();
     } else nextnode = 0;
     delete node;
     node = nextnode;
     --searchlength;
#ifdef DEBUG_MONOMIALFOREST
     ++monw;
     --monsz;
#endif
   };
   if(removetree) d_tree_map.erase(d_tree_map.find(v));
   d_set.erase(w);
#endif
};

void MonomialForest::goforit(TheRule * r1,TheRule * r2,
      AlgorithmApproach style) { 
#ifdef DEBUG_MONOMIALFOREST
  GBStream << "Rule 1 to be matched:\n";
  r1->print(GBStream);
  GBStream << "Rule 2 to be matched:\n";
  r2->print(GBStream);
#endif
  MatcherMonomial matcher;
  list<Match> L;
  if(UserOptions::s_UseSubMatch) {
    matcher.subMatch(r1->d_m,777,r2->d_m,777,L);
  };
 matcher.overlapMatch(r1->d_m,888,r2->d_m,888,L);
 typedef list<Match>::const_iterator LI;
 LI w2 = L.begin(), e2 = L.end();
 if(w2!=e2) {
   Polynomial result,temp;
   while(w2!=e2) { 
     const Match & aMatch = *w2;
#ifdef DEBUG_MONOMIALFOREST
     GBStream << "MXS: MatchL1 " << aMatch.const_left1() 
              << " Middle:" << *r1->rests().begin()
              << " MatchR1: " << aMatch.const_right1() << "<br>" << '\n';
#endif
     result.doubleProduct(aMatch.const_left1(),
                          *r1->rests().begin(),
                          aMatch.const_right1());
#ifdef DEBUG_MONOMIALFOREST
     GBStream << "MXS:result " << result << '\n';
     GBStream << "MXS: MatchL2 " << aMatch.const_left2() 
              << " Middle " << *r2->rests().begin()
              << " MatchR2: " << aMatch.const_right2() << "<br>" << '\n';
#endif
     temp.doubleProduct(aMatch.const_left2(),
                         *r2->rests().begin(),
                         aMatch.const_right2());
#ifdef DEBUG_MONOMIALFOREST
     GBStream << "MXS:temp " << temp << '\n';
#endif
     result -= temp;
#ifdef DEBUG_MONOMIALFOREST
     GBStream << "MXS:final result " << result << '\n';
#endif
     if(style==INLIST) {
       if(!result.zero()) d_to_be_added.push_back(result);
     } else if(style==INFOREST) {
       addPolynomial(result);
     } else errorh(__LINE__);
     ++w2;
   }; //while(w2!=e2) 
 }; // if(w2!=e2) 
};

void MonomialForest::makeRecent(AlgorithmApproach style) {
  ++d_htmlnumberfiles;
  GBStream.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles);
  SFSGNode::CRULES recent,notrecent;
#ifdef SFSGRULES_VECTOR
  recent.reserve(d_set.size()); notrecent.reserve(d_set.size());
#endif
#ifdef DEBUG_MONOMIALFOREST
PrintTheSet(GBStream);
#endif
  SET::iterator w  = d_set.begin(), e = d_set.end();
#ifdef DEBUG_MONOMIALFOREST
PrintTheSet(GBStream);
#endif
  TheRule * p = 0;
  while(w!=e) {
    p = *w;
    if(p) {
#ifdef DEBUG_MONOMIALFOREST
      GBStream << "S:rule:";
      p->print(GBStream);
      GBStream << '\n';
#endif
    } else {
#ifdef DEBUG_MONOMIALFOREST
      GBStream << "0 pointer?\n";
#endif
    };
    if(p->d_recent) {
      recent.push_back(p);
      p->d_recent = false;
    } else {
      notrecent.push_back(p);
    };
    ++w;
  };
#ifdef DEBUG_MONOMIALFOREST
GBStream << "*recent.begin():" << *recent.begin() << '\n';
PrintTheSet(GBStream);
#endif
  SFSGNode::CRULES::iterator ww,ee,ww2,ee2;
  TheRule * one = 0;
  TheRule * two = 0;
  ww  = recent.begin(); ee = recent.end();
  while(ww!=ee) {
    one = *ww;
#ifdef DEBUG_MONOMIALFOREST
GBStream << "one:" << one << '\n';
PrintTheSet(GBStream);
#endif
    goforit(one,one,style); // the "diagonal"
    ww2  = ww;ee2 = ee;
    ++ww2;
    while(ww2!=ee2) {
#ifdef DEBUG_MONOMIALFOREST
GBStream << "two:" << two << '\n';
#endif
      two = *ww2;
      goforit(one,two,style);
      goforit(two,one,style);
      ++ww2;
    };
    ++ww;
  }; // recent cross recent
  ww  = recent.begin(); ee = recent.end();
  while(ww!=ee) {
    one = *ww;
    ww2  = notrecent.begin(), ee2 = notrecent.end();
    while(ww2!=ee2) {
      two = *ww2;
      goforit(one,two,style);
      goforit(two,one,style);
      ++ww2;
    };
    ++ww;
  }; // recent cross notrecent union notrecent cross recent
};

void MonomialForest::copyIntoList(list<Polynomial> & L) const {
  Polynomial p,q;
  Term t;
  SET::const_iterator w = d_set.begin(), e = d_set.end();
  while(w!=e) {
    TheRule * r = *w;
    t.assign(r->d_m);
    q = t;
    typedef list<Polynomial>::const_iterator LI;
    LI ww = r->rests().begin(), ee = r->rests().end();
    while(ww!=ee) {
      p = *ww;
      p += q;
      L.push_back(p);
      ++ww;
    };
    ++w;
  };
};

void MonomialForest::reduceIt(SFSGNode * & childacceptor,SFSGNode * & childgiver,
      MonomialIterator & monw,
      const list<SFSGNode *> & acceptorpassed, 
      const list<SFSGNode *> & giverpassed,
      int & monsz,SET::iterator & w,SET::iterator & e) {
#ifdef DEBUG_MONOMIALFOREST
  ++d_htmlnumberfiles;
  GBStream.swapfiles("typescript.","answers/typescript.",d_htmlnumberfiles);
  GBStream << "giverpassed:";
  myprint(GBStream,giverpassed);
  GBStream << '\n';
  GBStream << "childacceptor:";
  childacceptor->print(GBStream);
  GBStream << '\n';
  GBStream << "childgiver:";
  childgiver->print(GBStream);
  GBStream << '\n';
#endif
  TheRule * giverrule = childgiver->rules(giverpassed.size());
  if(giverrule) {
    // We are now able to reduce this rule and reset the iterator
    if(giverrule->rests().size()>1) {
      GBStream << "There should not be more than one rule!!!\n";
      errorh(__LINE__);
    };
    // We can reduce the preceeding rule!!!!
#ifdef DEBUG_MONOMIALFOREST
    GBStream << "We can reduce the preceeding rule\n";
    GBStream << "We have:\n";
#endif
    TheRule * reducingrule = giverrule;
    const Monomial & reducingLHS = reducingrule->d_m;
    const Polynomial & reducingRHS = *reducingrule->rests().begin();
    TheRule * rule = * w;
    const Monomial & LHS = rule->d_m;
    Polynomial RHS(*rule->rests().begin());
#ifdef DEBUG_MONOMIALFOREST
    rule->print(GBStream,SIMPLE);
    GBStream << '\n';
    GBStream << "reducingrule: ";
    reducingrule->print(GBStream,SIMPLE);
    GBStream << '\n';
    GBStream << "acceptorpassed:";
    myprint(GBStream,acceptorpassed);
    GBStream << '\n';
    GBStream << "giverpassed:";
    myprint(GBStream,giverpassed);
    GBStream << '\n';
    GBStream << "monsz:" << monsz << '\n';
    GBStream << "*monw:" << *monw << '\n';
    GBStream << "childacceptor:";
    childacceptor->print(GBStream);
    GBStream << "\nchildgiver:";
    childgiver->print(GBStream);
    GBStream << "\n\n\n";
#endif
    int diff = LHS.numberOfFactors()-reducingLHS.numberOfFactors()
               - (monsz - 1);
#ifdef DEBUG_MONOMIALFOREST
    GBStream << "diff: " << diff << '\n';
#endif
    if(diff<0) {
      GBStream << "LHS.numberOfFactors() " 
               << LHS.numberOfFactors() << '\n';
      GBStream << "LHS:" << LHS << '\n';
      GBStream << "reducingLHS.numberOfFactors() " 
               <<  reducingLHS.numberOfFactors() << '\n';
      GBStream << "reducingLHS " 
               <<  reducingLHS << '\n';
      GBStream << "monsz " << monsz << '\n';
      GBStream << "(monsz - 1) " << (monsz - 1) << '\n';
      errorh(__LINE__);
    };
    Monomial before,after;
    MonomialIterator makebefore = LHS.begin();
    while(diff) {
#ifdef DEBUG_MONOMIALFOREST
      GBStream << "mulitplying against before:" << *makebefore << '\n';
#endif
      before *= (*makebefore); 
      ++makebefore;--diff;
    };
#ifdef DEBUG_MONOMIALFOREST
    GBStream << "before is now:" << before << '\n';
#endif
    SFSGNode * lastInChain = childacceptor;
    ++monw;--monsz;
    if(monsz) {
#ifdef DEBUG_MONOMIALFOREST
      GBStream << "looking for " << *monw << '\n';
#endif
      vector<SFSGNode*>::const_iterator ff =lastInChain->find_forward(*monw);
      if(lastInChain->isforwardend(ff)) errorh(__LINE__);
      while(monsz!=0 && !lastInChain->isforwardend(ff)) {
         GBStream << "mulitplying against after:" << *monw << '\n';
         after *= (*monw);
         lastInChain = *ff;
         --monsz;
         ff =lastInChain->find_forward(*monw);
         if(monsz!=0) ++monw;
      };
    if(monsz!=0) {
        GBStream << "monsz:" << monsz << '\n';
        errorh(__LINE__);
       };
    };
#ifdef DEBUG_MONOMIALFOREST
    GBStream << "after is now:" << after << '\n';
#endif
    Polynomial change;
    change.doubleProduct(before,reducingRHS,after);
#ifdef DEBUG_MONOMIALFOREST
    GBStream << "change is now:" << change << '\n';
    PrintTheSet(GBStream);
    GBStream << "before reducing RHS:";
    GBStream << RHS;
    GBStream << '\n';
#endif
    RHS -= change;
#ifdef DEBUG_MONOMIALFOREST
    GBStream << "reduced poly is now:";
    GBStream << RHS;
    GBStream << '\n';
    GBStream << "Getting rid of rule:\n";
    PrintTheSet(GBStream);
#endif
    removeRule(w);
#ifdef DEBUG_MONOMIALFOREST
    GBStream << "Got rid of rule:\n";
    PrintAllTrees(GBStream);
    PrintTheSet(GBStream);
#endif
    if(RHS.zero()) {
      w = d_set.lower_bound(rule);
    } else {
      w = addPolynomialPrivate(RHS);
    };
#ifdef DEBUG_MONOMIALFOREST
    GBStream << "Before deleting rule\n";
    PrintTheSet(GBStream); 
#endif
    //delete rule;
#ifdef DEBUG_MONOMIALFOREST
    GBStream << "After deleting rule\n";
    PrintTheSet(GBStream);
#endif
    e = d_set.end(); 
  };
};

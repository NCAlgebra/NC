// Mark Stankus 1999 (c)
// SFSGNode.h

#ifndef INCLUDED_SFSGNODE_H
#define INCLUDED_SFSGNODE_H

#include "TheRule.hpp"
#include "GBStream.hpp"
#include "ItoString.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Polynomial.hpp"
#include "Debug1.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#include <list>
#else
#include <vector.h>
#include <list.h>
#endif
#define DEBUG_SFSGNODE

void printForest();

class SFSGNode {
  static void errorh(int);
  static void errorc(int);
  static int s_number;
  int d_number;
  Variable d_v;
  int d_number_of_parents;
  vector<SFSGNode *> d_forward;
public:
  typedef list<TheRule*> CRULES;
private:
  CRULES * d_rules;
public:
  PrintStyle d_style; 
  SFSGNode(const Variable & v) : d_v(v), d_number_of_parents(0), d_rules(0), 
      d_style(FULL) {
    d_number = s_number;
#ifdef DEBUG_SFSGNODE
    GBStream << "Node(#" << d_number << "): " << v << ' ' << this << '\n';
#endif
    ++s_number;
  };
  ~SFSGNode(){};
  void addParent() { ++d_number_of_parents;};
  void removeParent() { --d_number_of_parents;};
  int number() const { return d_number;};
  const Variable & data() const { return d_v;};
    // Facts about parents
  int numberOfParents() const { return d_number_of_parents;};
    // Facts about children:
    // Does this node have any children?
  bool hasChildren() const {
    return d_forward.begin()!=d_forward.end();
  };
    // Does this node have exactly one child?
  bool hasOneChild() const {
    typedef vector<SFSGNode *>::const_iterator VI;
    VI w = d_forward.begin(), e = d_forward.end();
    bool result = w!=e;
    if(result) {
      ++w;
      result = e==w;
    };
    return result;
  };
    // Does this node have child with variable?
  bool hasChild(const Variable & v,SFSGNode * & ptr) const;
    // Does this node have child with variable?
  bool hasChild(const Variable & v,
                vector<SFSGNode *>::const_iterator & iter) const { 
    typedef vector<SFSGNode*>::const_iterator VI;
    bool result = false;
    VI w = d_forward.begin(), e = d_forward.end();
    while(w!=e) {
      if((*w)->data()==v) {
        result = true;
        iter = w;
        break;
      };
      ++w;
    };
    return result;
  };
    // Give the children of *p to *this if the variables do not coincide.
  void noChildrenAdoptAllChildrenOf(SFSGNode * p) {
    d_forward = p->d_forward;
    typedef vector<SFSGNode*>::const_iterator VI;
    VI w = d_forward.begin(), e = d_forward.end();
    while(w!=e) {
      (*w)->addParent();
      GBStream << "Connecting " << d_number << " to " 
               << (*w)->d_number << '\n'; 
      ++w;
    };
  };
  void adoptAllChildrenOf(SFSGNode * p) {
    GBStream << "Node " << number() 
             << " is trying to adopt the children of " << p->number() << '\n';
    typedef vector<SFSGNode*>::const_iterator VI;
    bool todo = true;
    VI w,e;
    Variable v;
    while(todo) {
      todo = false;
      w = p->d_forward.begin(), e = p->d_forward.end();
      while(w!=e && !todo) {
        v = (*w)->data(); 
        VI ww;
        if(hasChild(v,ww)) { 
#ifdef DEBUG_SFSGNODE
          GBStream << "NOT adding edge from ";
          print(GBStream,SIMPLE);
          GBStream << " to ";
          (*w)->print(GBStream,SIMPLE);
#endif
          ++w;
	} else {
#ifdef DEBUG_SFSGNODE
          GBStream << "Adding edge from ";
          print(GBStream,SIMPLE);
          GBStream << " to ";
          (*w)->print(GBStream,SIMPLE);
#endif
          adoptChild(*w);
          todo = true;
        };
      }; // while(w!=e && !todo)
    }; // while(todo) 
  };
    // *this makes *x a child OR (if there is a child with the same variable)
    // cause an error
  void adoptChild(SFSGNode *  x)  {
    typedef vector<SFSGNode*>::const_iterator VI;
    if(d_number==x->d_number) {
      GBStream.flush();
      GBStream << "<br>Trying to add a connection from node number "
               << d_number << " to ITSELF!!!\n";
      GBStream.flush();
      printForest();
      errorh(__LINE__);
     };
#ifdef DEBUG_SFSGNODE
    GBStream << "MXS:Connecting " << d_number << " to " << x->d_number << " \n";
#endif
    Variable v(x->data());
    VI w;
    bool found = false;
    if(hasChild(x->data(),w)) {
      found = true;
      if(*w!=x) {
#ifdef DEBUG_SFSGNODE
        GBStream << "Trying to insert edge from ";
        print(GBStream,SIMPLE);
        GBStream << " to ";
        x->print(GBStream,SIMPLE);
        GBStream << " and a link to ";
        (*w)->print(GBStream,SIMPLE);
        GBStream << " found.\n";
#endif
        errorh(__LINE__);
      };
    };
    if(!found) {
      d_forward.push_back(x);
      x->addParent();
    };
  };
    // *this makes *x a child OR (if there is a child with the same variable)
  vector<SFSGNode*>::const_iterator find_forward(const Variable & v) {
    GBStream << "Try to avoid this subroutine. Depreciated.\n";
    vector<SFSGNode *>::const_iterator w = d_forward.end();
    (void) hasChild(v,w);
    return w;
  };
  SFSGNode* find_forward_error(const Variable & v) {
    vector<SFSGNode *>::const_iterator w = d_forward.end();
    if(!hasChild(v,w)) {
      GBStream << "find_forward_error was expecting " << v << '\n';
      errorh(__LINE__);
    };
    return *w;
  };
  SFSGNode* find_force_forward(const Variable & v) {
    SFSGNode * result;
    vector<SFSGNode *>::iterator w = d_forward.end();
    if(hasChild(v,w)) {
      result = *w;
    } else {
      result = new SFSGNode(v);
      adoptChild(result);
    };
    return result;
  };
  SFSGNode* find_force_forward(const Monomial & m) {
    if(m.one()) errorh(__LINE__);
    SFSGNode * p = this;
    MonomialIterator w = m.begin();
    int sz = m.numberOfFactors();
    if(*m.begin()!=d_v) errorh(__LINE__);
    --sz;++w;
    while(sz) {
#ifdef DEBUG_SFSGNODE
      GBStream << "MXS:forcing forward" << *w << '\n';
#endif
      p = p->find_force_forward(*w);
      --sz;++w;
    };
    return p;
  };
  const vector<SFSGNode*> & forward() const {
    GBStream << "Nonconst\n";
    return d_forward;
  };
  vector<SFSGNode*> & forward() {
    GBStream << "const\n";
    return d_forward;
  };
  bool isforwardend(const vector<SFSGNode*>::const_iterator & w) { 
    return w==d_forward.end(); 
  }; 
  bool hasRule(TheRule * p) const {
#ifdef DEBUG_SFSGNODE
    GBStream << "Calling hasRule with " << p << '\n';
    print(GBStream);
#endif
    bool result = false;
    if(!!d_rules) {
      typedef CRULES::const_iterator VCI;
      VCI w = d_rules->begin(),e = d_rules->end();
      while(w!=e && !result) {
        if(*w==p) result = true;
        ++w;
      };
    };
    return result;
  };
  void forgetRule(TheRule * p) {
#ifdef DEBUG_SFSGNODE
    GBStream << "Calling forgetRule with " << p << '\n';
    print(GBStream);
#endif
    bool found = false;
    if(!!d_rules) {
      typedef CRULES::iterator VI;
      VI w = d_rules->begin(),e = d_rules->end();
      while(w!=e && !found) {
        if(*w==p) {
          found = true;
          GBStream << "About to erase a rule\n";
          d_rules->erase(w);
          GBStream << "erased the rule\n";
          break;
        };
        ++w;
      };
      if(!found) errorh(__LINE__);
      if(d_rules->empty()) {
 GBStream << "d_rules is empty\n";
        delete d_rules;
        d_rules = 0;
      };
    };
  };
  bool hasRule(int n) const {
#ifdef DEBUG_SFSGNODE
    GBStream << "<br><table><tr><td>\n";
    GBStream << "Calling hasRule with " << n << '\n';
    print(GBStream);
#endif
    bool result = !!d_rules;
    if(result) {
      typedef CRULES::const_iterator VCI;
      VCI w = d_rules->begin(),e = d_rules->end();
      while(w!=e) {
        const int m = (*w)->d_m.numberOfFactors();
        if(m<n) {
          ++w;
        } else {
          result = (m==n);    
          break;
        };
      }; // while(w!=e) 
    };
#ifdef DEBUG_SFSGNODE
    GBStream << "<br>Done Calling hasRule with " << n << '\n';
    print(GBStream);
    GBStream << "result: " << result << "<br>" << '\n';
    GBStream << "</td></tr></table><br>\n";
#endif
    return result;
  };
#if 0
  bool hasRuleLarger(int n) const {
    bool result = !!d_rules;
    if(result) {
      typedef CRULES::const_iterator VCI;
      VCI w = d_rules->begin(),e = d_rules->end();
      while(w!=e) {
        const int m = (*w)->d_m.numberOfFactors();
        if(m>n) {
          ++w;
        } else {
          result = (m==n);    
          break;
        };
      }; // while(w!=e) 
    };
    return result;
  };
#endif
    // add the rules in order numerically
  void assignRule(TheRule * p) {
    if(!d_rules) {
      d_rules = new CRULES;
      d_rules->push_back(p);
    } else {
      const int n = p->d_m.numberOfFactors();
      CRULES::iterator w = d_rules->begin(), e = d_rules->end();
      while(w!=e) {
        const int m = (*w)->d_m.numberOfFactors();
        if(m>n) {
          d_rules->insert(w,p);
          break;
        } else if(m==n)  errorh(__LINE__); 
        ++w;
      };
      if(w==e) d_rules->push_back(p);
    }
    GBStream << "Assigned rule:\n";
    printPaths(GBStream);
  };
  bool hasAnyRules() const {
    return !!d_rules;
  }; 
  void forgetChild(const Variable & v) {
    bool found = false;
    vector<SFSGNode*>::iterator w = d_forward.begin(), e = d_forward.end();
    while(w!=e) {
      if((*w)->data()==v) {     
        found = true;
        d_forward.erase(w);
        break;
      };
      ++w;
    };
    if(!found) errorh(__LINE__);
  };
  void forgetRules() {
    if(d_rules) {
      CRULES::iterator w = d_rules->begin(), e = d_rules->end();
      while(w!=e) {
        *w = 0;
        ++w;
      };
      delete [] d_rules;
      d_rules = 0;
    };
  };
  TheRule  * rules(int n) {
    typedef CRULES::const_iterator VI;
    TheRule * result = 0;
    if(d_rules) {
      VI w = d_rules->begin(), e = d_rules->end();
      while(w!=e) {
        const int m = (*w)->d_m.numberOfFactors();
        if(m<=n) {
          result = *w;
          break;
        };
        ++w;
      };
    };
    return result;
  };
  void print(MyOstream & os) const { print(os,d_style);};
  void print(MyOstream & os,PrintStyle s) const;
  void printPaths(list<pair<int,int> >,Monomial,MyOstream & os) const;
  void printPaths(MyOstream & os) const;
  bool NodeGivesPathToLeaf() {
    SFSGNode * ptr = this;
    while(ptr->hasOneChild() && ptr->numberOfParents()<=1) {
      ptr = *ptr->forward().begin();
    };
    return !(ptr->hasChildren()&&(ptr->numberOfParents()<=1));
  };
   // number of nodes down the given path until a node
   // with two parents is found
  int FirstWithMoreThanOneParent(MonomialIterator monw,int monsz) {
    SFSGNode * ptr = this;
    if(data()!=*monw) errorh(__LINE__);
    int result = 0;
    while(ptr->numberOfParents()<=1&&monsz>0) {
      ++monw;--monsz;++result;
      GBStream << "Forward on " << *monw << '\n';
      if(monsz) ptr = ptr->find_forward_error(*monw);
    };
    return result;
  };
};
#endif

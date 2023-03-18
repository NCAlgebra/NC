// Mark Stankus 1999 (c)
// PrinterAttributes.hpp

#ifndef INCLUDED_PRINTERATTRIBUTES_H
#define INCLUDED_PRINTERATTRIBUTES_H

class GroebnerRule;
class Polynomial;
class Term;
class Field;
class Monomial;
class Variable;

class PrinterAttributes {
  void setit(char *& x,char * ptr) {
    x = new char[strlen(ptr)+1];
    strcpy(x,ptr);
  };
  void clearit(char * & x) {
    delete [] x;
    x = 0;
  };
public:
  PrinterAttributes() { zeroAll();setAscii();};
  ~PrinterAttributes() {};

    // rule
  void (*f_start_rule)(const GroebnerRule &);
  void (*f_between_rule)(const GroebnerRule &);
  void (*f_after_rule)(const GroebnerRule &);

  char * d_start_rule;
  char * d_between_rule;
  char * d_after_rule;

    // polynomial
  void (*f_start_polynomial)(const Polynomial &);
  void (*f_between_polynomial_plus)(const Polynomial &);
  void (*f_between_polynomial_minus)(const Polynomial &);
  void (*f_after_polynomial)(const Polynomial &);

  char * d_start_polynomial;
  char * d_between_polynomial_plus;
  char * d_between_polynomial_minus;
  char * d_after_polynomial;

    // term
  void (*f_start_term)(const Term &);
  void (*f_between_term)(const Term &);
  void (*f_after)(const Term &);

  char * d_start_term;
  char * d_between_term;
  char * d_after_term;

    // monomial
  void (*f_start_monomial)(const Monomial &);
  void (*f_between_monomial)(const Monomial &);
  void (*f_end_monomial)(const Monomial &);

  char * d_start_monomial;
  char * d_between_monomial;
  char * d_after_monomial;

    // variable
  void (*f_start_variable)(const Variable &);
  void (*f_end_variable)(const Variable &);

  char * d_start_variable;
  char * d_after_variable;

  void setAscii() {
    setit(d_start_rule," ");
    setit(d_between_rule," -> ");
    setit(d_after_rule," ");

    setit(d_start_polynomial," ");
    setit(d_between_polynomial_plus," + ");
    setit(d_between_polynomial_minus," - ");
    setit(d_after_polynomial," ");

    setit(d_start_term," ");
    setit(d_between_term," * ");
    setit(d_after_term," ");

    setit(d_start_monomial," ");
    setit(d_between_monomial," ** ");
    setit(d_after_monomial," ");

    setit(d_start_variable," ");
    setit(d_after_variable," ");
  };
  void setHtml() {
    setit(d_start_rule," ");
    setit(d_between_rule," -> ");
    setit(d_after_rule," ");

    setit(d_start_polynomial," ");
    setit(d_between_polynomial_plus," + ");
    setit(d_between_polynomial_minus," - ");
    setit(d_after_polynomial," ");

    setit(d_start_term," ");
    setit(d_between_term,"&nbsp;");
    setit(d_after_term," ");

    setit(d_start_monomial," ");
    setit(d_between_monomial,"&nbsp;");
    setit(d_after_monomial," ");

    setit(d_start_variable," ");
    setit(d_after_variable," ");
  };
  void setTeX() {
    setit(d_start_rule," ");
    setit(d_between_rule," \rightarrow ");
    setit(d_after_rule," ");

    setit(d_start_polynomial," ");
    setit(d_between_polynomial_plus," + ");
    setit(d_between_polynomial_minus," - ");
    setit(d_after_polynomial," ");

    setit(d_start_term," ");
    setit(d_between_term,"\\ ");
    setit(d_after_term," ");

    setit(d_start_monomial," ");
    setit(d_between_monomial," ");
    setit(d_after_monomial," ");

    setit(d_start_variable," ");
    setit(d_after_variable," ");
  };
  void clear() {
    clearit(d_start_rule);
    clearit(d_between_rule);
    clearit(d_after_rule);

    clearit(d_between_polynomial_plus);
    clearit(d_between_polynomial_minus);
    clearit(d_after_polynomial);

    clearit(d_start_term);
    clearit(d_between_term);
    clearit(d_after_term);

    clearit(d_start_monomial);
    clearit(d_between_monomial);
    clearit(d_after_monomial);

    clearit(d_start_variable);
    clearit(d_after_variable);
  };
  void zeroAll() {
    f_start_rule = 0;
    f_between_rule = 0;
    f_after_rule = 0;
    d_start_rule = 0;
    d_between_rule = 0;
    d_after_rule = 0;
    f_start_polynomial = 0;
    f_between_polynomial_plus = 0;
    f_between_polynomial_minus = 0;
    f_after_polynomial = 0;
    d_start_polynomial = 0;
    d_between_polynomial_plus = 0;
    d_between_polynomial_minus = 0;
    d_after_polynomial = 0;
    f_start_term = 0;
    f_between_term = 0;
    f_after = 0;
    d_start_term = 0;
    d_between_term = 0;
    d_after_term = 0;
    f_start_monomial = 0;
    f_between_monomial = 0;
    f_end_monomial = 0;
    d_start_monomial = 0;
    d_between_monomial = 0;
    d_after_monomial = 0;
    f_start_variable = 0;
    f_end_variable = 0;
    d_start_variable = 0;
    d_after_variable = 0;
  };
};
#endif

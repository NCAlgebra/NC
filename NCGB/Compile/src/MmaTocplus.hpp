// MmaTocplus.h

#ifndef INCLUDED_MMATOCPLUS_H
#define INCLUDED_MMATOCPLUS_H

class Source;
class Variable;
class Monomial;
class INTEGER;
class Field;
class Term;
class Polynomial;
class GroebnerRule;
class GBString;

void MmaTocplus(Source &  source,Variable & tree);
void MmaTocplus(Source &  source1,Monomial & mono);
void MmaTocplus(Source &  source,INTEGER & I);
void MmaTocplus(Source &  source1,Field & qf);
void MmaTocplus(Source &  source1,Term & term);
void MmaTocplus(Source &  source1,Polynomial & poly); 
void MmaTocplus(Source &  source1,GroebnerRule & rule);
void MmaTocplus(Source &  source1,GBString & ss);
#endif

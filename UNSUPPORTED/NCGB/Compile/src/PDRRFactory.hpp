// PDRRFactory.h

#ifndef INCLUDED_PDRRFACTORY_H
#define INCLUDED_PDRRFACTORY_H

#ifndef INCLUDED_FACTORY_H
#include "Factory.hpp"
#endif
class MngrStart;
class MngrSuper;
#ifndef INCLUDED_PDREMOVEREDUNDENT_H
#include "PDRemoveRedundent.hpp"
#endif
#ifndef INCLUDED_REMOVEREDUNDENT_H
#include "RemoveRedundent.hpp"
#endif

class PDRRFactory : public Factory<RemoveRedundent> {
  PDRRFactory(); 
    // not implemented
  PDRRFactory(const PDRRFactory &); 
    // not implemented
private:
  MngrSuper & d_start;
public:
  explicit PDRRFactory(MngrSuper & start) : 
      Factory<RemoveRedundent>(s_ID), d_start(start) {};
  virtual ~PDRRFactory();
  virtual RemoveRedundent * create();
  static const int s_ID;
};
#endif

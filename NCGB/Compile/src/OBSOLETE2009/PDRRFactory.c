// PDRRFactory.c

#include "PDRRFactory.hpp"
#include "RecordHere.hpp"

#ifndef INCLUDED_VERSION_H
#include "version.hpp"
#endif
#ifndef INCLUDED_MNGRSUPER_H
#include "MngrSuper.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "MyOstream.hpp"
#include "GBStream.hpp"
#ifndef INCLUDED_IDVALUE_H
#include "idValue.hpp"
#endif

PDRRFactory::~PDRRFactory(){};

RemoveRedundent * PDRRFactory::create() {
  RemoveRedundent * result = 0;
  if(isPD()) {
    const FactControl & fc = ((MngrSuper &) d_start).GetFactBase();
    RECORDHERE(result  = new PDRemoveRedundent(fc);)
  } else {
    GBStream << "There is a mix up in the binary.\n";
    Debug1::s_mail_to_message_with();
    GBStream << "isPD() with PDRRFactory\n";
  }
  return result;
};

const int PDRRFactory::s_ID = idValue("::PDRRFactory");


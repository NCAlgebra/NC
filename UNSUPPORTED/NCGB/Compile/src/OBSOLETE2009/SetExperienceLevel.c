// SetExperienceLevel.c

#include "GBIO.hpp"
#include "stringGB.hpp"
#include "ExperienceLevel.hpp"
#include "Command.hpp"
#include "Source.hpp"
#include "Sink.hpp"


void _SetExperienceLevel(Source & so,Sink & si) {
  stringGB x;
  so  >> x;
  if(x=="Novice") {
    ExperienceLevel::s_setExperienceLevel(0,false);
  } else if(x=="Developer") {
    ExperienceLevel::s_setExperienceLevel(1,false);
  } else {
    ExperienceLevel::s_setExperienceLevel(0,false);
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp1SetExp("SetExperienceLevel",1,_SetExperienceLevel);

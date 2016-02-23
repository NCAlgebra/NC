// ExperienceLevel.c

#include "ExperienceLevel.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"


void ExperienceLevel::s_setExperienceLevel(int n,bool silent) {
  if(!silent) {
    GBStream << "\nPrevious experience level:\n";
    ExperienceLevel::s_announceExperience();
  };
  ExperienceLevel::s_experienceLevel = n;
  if(!silent) {
    GBStream << "\nNew experience level:\n";
    ExperienceLevel::s_announceExperience();
  };
};

void ExperienceLevel::s_announceExperience() {
  GBStream << s_experienceLevel << '\n';
};

int ExperienceLevel::s_experienceLevel = 0;
  // ExperienceLevel::s_experienceLevel can restrict the users from
  // preforming various tasks. See PlatformSpecific.c also.

#include "PlatformSpecific.hpp"
#include "StartEnd.hpp"

class setDefaultExperience : public AnAction {
public:
  setDefaultExperience() : AnAction("setDefaultExperience"){};
  void action() {
    ExperienceLevel::s_setExperienceLevel(
    PlatformSpecific::s_default_user_level,true);
  };
};

AddingStart temp1ExperienceLevel(new setDefaultExperience);

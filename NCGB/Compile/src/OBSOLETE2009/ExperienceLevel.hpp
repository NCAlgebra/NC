// ExperienceLevel.h

#ifndef INCLUDED_EXPERIENCELEVEL_H
#define INCLUDED_EXPERIENCELEVEL_H

class ExperienceLevel {
  static int s_experienceLevel;
public:
  static bool s_developer() { return s_experienceLevel==1;};
  static void s_setExperienceLevel(int,bool silent);
  static int  s_getExperienceLevel() { return s_experienceLevel; };
  static void s_announceExperience();
};
#endif

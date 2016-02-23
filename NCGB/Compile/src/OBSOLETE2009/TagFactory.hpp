// Mark Stankus 1999 (c)
// TagFactory.hpp

#ifndef INCLUDED_TAGFACTORY_H
#define INCLUDED_TAGFACTORY_H

class Tag;

class TagFactory {
  TagFactory(){};
public:
  virtual ~TagFactory();
  virtual Tag * Create() = 0;
};
#endif

// Mark Stankus 1999 (c) 
// Explanation.nwh

class Explanation {
public:
  Explanation(){};
  virtual ~Explanation() = 0;
  virtual void doSomething(void *) = 0;
};



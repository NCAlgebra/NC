// AuxilaryData.h

#ifndef INCLUDED_AUXILARYDATA_H
#define INCLUDED_AUXILARYDATA_H

class AuxilaryData {
  AuxilaryData(const AuxilaryData &);
    // not implemented
protected:
  AuxilaryData(){};
public:
  virtual ~AuxilaryData() = 0;
  void operator =(const AuxilaryData& d) {assign(d);}; 
  bool operator ==(const AuxilaryData & d) const {return equal(d);};
  bool operator !=(const AuxilaryData & d) const {return !equal(d);};
  virtual void assign(const AuxilaryData &d) = 0;
  virtual bool equal(const AuxilaryData &d) const = 0;
  virtual void vClearData(int) = 0;
};
#endif

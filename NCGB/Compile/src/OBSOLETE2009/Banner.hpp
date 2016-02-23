// Mark Stankus 1999 (c)
// Banner.hpp

#ifndef INCLUDED_BANNER_H
#define INCLUDED_BANNER_H

#include "Recipient.hpp"
#include "MyOstream.hpp"
#include <vector>

class Banner : public Recipient {
protected:
  const char * d_font;
  float d_columnwidth;
  vector<float> d_rulewidth;
public:
  Banner(MyOstream & os,int columns = 1,const char * FontSize = "normalsize") 
    : d_font(FontSize), d_rulewidth() {
    d_rulewidth = RegOutRule(os,FontSize,columns);
    if(columns==1) {
      d_columnwidth=6;
    } else {
      d_columnwidth=3.2f;
    };
  };
  virtual ~Banner() = 0;
  virtual void action(const BroadCastData &) const = 0;
  virtual Recipient * clone() const = 0;
private:
  vector<float> RegOutRule(MyOstream & os,const char * const font,int columns) {
    vector<float> result;
    if(strcmp(font,"normalsize")==0) {
      result.push_back(1.879f);
      result.push_back(1.923f);
      result.push_back(1.701f);
      result.push_back(1.45f);
      result.push_back(2.18f);
    } else if(strcmp(font,"small")==0) {
      if(columns==1) {
        result.push_back(1.95f);
        result.push_back(2.0f);
        result.push_back(1.798f);
        result.push_back(1.56f);
        result.push_back(2.23f);
      } else {
        result.push_back(0.535f);
        result.push_back(0.573f);
        result.push_back(0.399f);
        result.push_back(0.137f);
        result.push_back(0.818f);
      };
    } else {
      os << "Font size ";
      os << font;
      os << "not supported. Using small\n";
      result = RegOutRule(os,"small",2);
    };
    return result;
  };
};
#endif

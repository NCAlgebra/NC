// Mark Stankus 1999 
// SPISource.hpp

class SPISource {
public:
  SPISource(){};;
  virtual ~SPISource() = 0;
  bool getNext(SPI & x) = 0;
};

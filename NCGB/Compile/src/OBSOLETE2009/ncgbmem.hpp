// (c) Mark Stankus 1999
// ncgbmem.c

#ifndef INCLUDED_NCGBMEM_P
#define INCLUDED_NCGBMEM_P

#include <stddef.h>

class ncgbmem {
  char * d_s;
  int    d_alloc;
  size_t d_len;
public:
  ncgbmem(char * s,size_t len);
  void * get_memory() {
    ++d_alloc;
    return new char[d_len]; 
  };
  void release_memory(void * p) {
    --d_alloc;
    delete p;
  }; 
};

inline ncgbmem::ncgbmem(char * s,size_t len) : d_s(s), d_alloc(0), d_len(len) {};
#endif

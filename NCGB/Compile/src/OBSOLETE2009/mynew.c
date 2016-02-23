//mynew.c

#include "mynew.hpp"
#include "choose_mynew.hpp"
#ifdef MYNEW
#include "RecordHere.hpp"
#include "MyOstream.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif
#include <stdio.h>
#include <malloc.h>
#include "Debug1.hpp"

#if 0
bool print_news = false;
bool print_deletes = false;
#else
bool print_news = true;
bool print_deletes = true;
#endif
bool print_havenot = false;
bool print_wierd_deletes = false;

#define RECORDWHERENEW

#ifdef RECORDWHERENEW
int s_New_Pointer_Current_Max = -999;
int s_First_Free = -999;
int s_allNewPointer_Count = 0;
void * * s_allPointersNewed = 0;
void * * s_allPointersPastEnd = 0;
void * * s_New_Pointers = 0; // 0 terminated list of void *'s
char * * s_New_File = 0;     // 0 terminated list of char *'s
int    * s_New_Line = 0;     // 0 terminated list of char *'s
int      s_Max_New;
int s_new_count = 0;
#endif

inline void reportondeleted(int j) {
  char * q = s_New_File[j];
  if(q) {
    if(print_deletes) printf("{newed in [%s,%d] }",q,s_New_Line[j]);
  } else {
    if(print_deletes) printf("{newed in [NOT RECORDED] }");
  }
};


void * procedure_new(size_t sz) {
#ifdef RECORDWHERENEW
  int max_value =1000000;
  if(s_Max_New!=max_value) {
    s_Max_New = max_value;
    s_First_Free=-999;
    s_New_Pointer_Current_Max = 0;
    s_allPointersNewed = (void **) malloc(sizeof(void*)*(s_Max_New-1));
    s_allPointersPastEnd = s_allPointersNewed;
  };
  if(s_new_count>=s_Max_New) DBG();
  if(!s_New_Pointers) {
    s_New_Pointers = (void **)malloc(sizeof(void*)*(s_Max_New+1));
    s_New_File = (char**)malloc(sizeof(void*)*(s_Max_New+1));
    s_New_Line = (int *) malloc(sizeof(int)*(s_Max_New+1));
  };
#endif
  void * p = malloc(sz);
  *s_allPointersPastEnd = p;
  ++s_allPointersPastEnd;
  ++s_allNewPointer_Count;
  if(print_news) printf("This is the %d th pointer to be allocated",s_allNewPointer_Count);
#ifdef RECORDWHERENEW
  int place;
  if(s_First_Free==-999) {
    place = s_New_Pointer_Current_Max;
    ++s_New_Pointer_Current_Max;
  } else {
    place =s_First_Free;
    s_First_Free = s_New_Line[s_First_Free];
  };
  s_New_Pointers[place] = p;
#ifdef RECORDWHERENEW
  if(!s_RECORDHERE_File_Where&&s_inInitialize) {
    s_RECORDHERE_File_Where = (char *) malloc(strlen("Initialize")+1); 
    strcpy(s_RECORDHERE_File_Where,"Initialize"); 
    s_RECORDHERE_Line_Where = -999;
  };
#endif
  s_New_File[place] = s_RECORDHERE_File_Where;
  s_New_Line[place] = s_RECORDHERE_Line_Where;
#endif
  ++s_new_count;
  if(print_news) printf("\t...new[");
#ifdef RECORDWHERENEW
  if(s_RECORDHERE_File_Where) {
    if(print_news) printf("%s,%d",s_RECORDHERE_File_Where,s_RECORDHERE_Line_Where);
  } else {
#endif
    if(print_news) printf("NOT RECORDED");
#ifdef RECORDWHERENEW
  }
#endif
  if(print_news) {
    printf("][#%d](%d): %x\n",s_new_count,sz,p);
  };
  return p;
};

void * operator new(size_t sz) {
  return procedure_new(sz);
};


void operator delete(void * addr) {
  if(addr) { 
#ifdef RECORDWHERENEW
    bool found = false;
    int j=0;
    while(j<s_New_Pointer_Current_Max&&!found) {
      if(addr==s_New_Pointers[j]) {
        found = true;
        if(print_deletes) printf("\t...deleted ");
        reportondeleted(j);
        if(print_deletes) {
          printf(":  %x\n",addr);
        };
        s_New_Pointers[j] = 0;
        s_New_File[j] = 0;
        s_New_Line[j] = s_First_Free;
        s_First_Free = j;
      };
      ++j;
    };
    if(!found) {
      if(print_wierd_deletes) {
        printf("\t...trying to delete(%x) which has not been newed!!!\n",addr);
      };
      void * * p = s_allPointersNewed;
      while(p!=s_allPointersPastEnd) {
        if(*p==addr) {
          if(print_wierd_deletes) printf("Hey, this pointer was allocated at some point!!!\n");
          break;
        };
        ++p;
      };
      if(p==s_allPointersPastEnd) {
        if(print_wierd_deletes) printf("Hey, I have never seen this pointer!!!\n");
      };
    };
    --s_new_count;
#endif
    free(addr);
  };
};

void reportNew() {
  if(print_news) cout << "There are " << s_new_count << " new's which were not deleted.\n";
  cout.flush();
};

void reportAllUndeleted() {
  reportNew();
  void * * p = s_New_Pointers;
  char * * q = s_New_File;
  int    * r = s_New_Line;
  int cnt = 0;
  for(int i=0;i<s_Max_New;++i,++p,++q,++r) {
    if(*p) {
      ++cnt;
      if(print_havenot) printf("\t...have not deleted ");
      reportondeleted(i);
      if(print_havenot) printf("\n(%x)\n",*p);
    };
  };
};

void out_of_store() {
  cerr << "operator new failed: out of store\n";
};
#endif

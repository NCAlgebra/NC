// RecordHere.h 

#ifndef INCLUDED_RECORDHERE_H 
#define INCLUDED_RECORDHERE_H 

void addToFileStack(char *,int);  
void getFromFileStack();  

#if 0 
#define RECORDHERE(stuff)   addToFileStack(__FILE__,__LINE__);stuff;getFromFileStack();
#define RECORDHEREBEFORE  addToFileStack(__FILE__,__LINE__);
#define RECORDHEREAFTER   getFromFileStack();

#define RECORDNEW(stuff)   addToFileStack(__FILE__,__LINE__);stuff;getFromFileStack();
#define RECORDNEWBEFORE  addToFileStack(__FILE__,__LINE__);
#define RECORDNEWAFTER   getFromFileStack();

#define RECORDDELETE(stuff)   addToFileStack(__FILE__,__LINE__);stuff;getFromFileStack();
#define RECORDDELETEBEFORE  addToFileStack(__FILE__,__LINE__);
#define RECORDDELETEAFTER   getFromFileStack();
#else
#define RECORDHERE(stuff)   stuff
#define RECORDHEREBEFORE  
#define RECORDHEREAFTER   

#define RECORDNEW(stuff)   stuff
#define RECORDNEWBEFORE  
#define RECORDNEWAFTER   

#define RECORDDELETE(stuff)   stuff
#define RECORDDELETEBEFORE  
#define RECORDDELETEAFTER   
#endif

extern char * s_RECORDHERE_File_Where;
extern int    s_RECORDHERE_Line_Where;
extern bool   s_inInitialize;
#endif

// Mark Stankus (c) 1999
// dorenaming.cpp

#include <string>
#include <iostream>

main(int argc,char * argv[]) {
  int len;
  for(int i=1;i<argc;++i) {
    len = strlen(argv[i]);
    char * x = new char[len+1];
    strcpy(x,argv[i]);
    x[len-2] = '\0';
    cout << "ln -s " << argv[i] << "  " << x << '\n';
    delete [] x;
  };
  return 0;
};

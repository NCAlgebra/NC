// (c) Mark Stankus 1999
// FormOutput.cpp

#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "MyOstream.hpp"

char * * frontMatter = {
  "\\begin{document}\n","\\","normalsize","\n"
  "\\baselineskip=","12pt","\n","\\noindent\n",(char *)0
};

char * * endMatter = {"\\end{document}\n\\end\n",0};


DisplayPart * formSpreadsheet(MyOstream & os) {
  CompDisplayPart * result = new CompDisplayPart;
  ICopy<DisplayPart>  temp1(new StringDisplayPart(os,frontMatter));
  result->d_list.push_back(temp1);
  ICopy<DisplayPart>  temp2(new StringDisplayPart(os,endMatter));
  result->d_list.push_back(temp2);
  return result;
};

int _FormSpreadsheet(Source & source,Sink & sink) {
  stringGB x;
  source >> x;
  source.shouldBeEnd();
  sink.noOutput();
  ofstream ofs(s.value().chars());
  MyOstream os(ofs);
  DisplayPart * p = formSpreadsheet(os);
  p->perform();
  ofs.close();
  delete p;
};

AddingCommand temp1FormOutput("FormSpreadsheet",1,_FormSpreadsheet);


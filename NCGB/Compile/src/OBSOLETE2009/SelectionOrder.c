// SelectionOrder.c

#include "SelectionOrder.hpp"
#include "RecordHere.hpp"

SelectionOrder::SelectionOrder() : 
    d_ToRemove_p(new BaseSelectionOrder), p(*d_ToRemove_p) { 
  RECORDHERE(delete d_ToRemove_p;)
};

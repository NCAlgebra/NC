(* :Title: 	NCSort // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	NCSort` *)

(* :Summary:    NCSort is a sort routine which is implemented
                for NonCommutative expressions. It 
                uses a function NCGreater which is also in
                this package.
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :8/25/92:    Wrote program.
*)


BeginPackage["NCSort`",
      "NonCommutativeMultiply`","Global`","Ajize`",
      "System`","Errors`"];

Clear[NCSort];

NCSort::usage = 
     "NCSort[x] sorts x with respect to NCGreater. The \
      larger elements go to the left.";

Clear[NCGreater];

NCGreater::usage = 
       "NCGreater is an implementation of an order used \
        by NCSort.";

Clear[LeadingCoefficientOne];

LeadingCoefficientOne::usage = 
       "LeadingCoefficientOne is an option for NCGreater.";

Clear[SetHeadOrder];

SetHeadOrder::usage = 
     "When x is a list, SetHeadOrder[x] sets the head order to be x.";

Clear[WhatIsHeadOrder];

WhatIsHeadOrder::usage = 
     "WhatIsHeadOrder gives the HeadOrder.";

Begin["`Private`"];
CommutativeQ[Complex[x_,y_]]:=True;

(* 
    Sort items using NCGreater so that the largest elements
    of the list appear on the right hand side.
*)

NCSort[items_] :=  Sort[items,NCGreater[#2,#1]&];

NCSort[x___] :=  BadCall["NCSort",x];

Options[NCGreater]:= {LeadingCoefficientOne->True};

NCGreater[x_,x_,opts___] := False;

(*
     PROCESSING OF COMMUTATIVE VERSUS NONCOMMUTATIVE EXPRESSIONS 
*)

NCGreater[x_?CommutativeAllQ,y_?(Not[CommutativeAllQ[#]])&] := False;
NCGreater[y_?(Not[CommutativeAllQ[#]])&,x_?CommutativeAllQ]:= True;

(*
                  PROCESSING OF PLUS
*)
NCGreater[expr1_Plus,expr2_Plus,opts___] :=
Module[{list1,list2,top1,top2,lead1,lead2,normalize},
      normalize = LeadingCoefficientOne/. {opts} /. Options[NCGreater];
(*
      Turn the sums into lists so that we can 
      sort them.
*)
      list1 = Apply[List,expr1];
      list2 = Apply[List,expr2];
      list1 = NCSort[list1];
      list2 = NCSort[list2];
      If[normalize,
(*
                    Divide each expression by the coefficient 
                    of the leading term of each expression.
*)
                    top1 = list1[[-1]];
                    top2 = list2[[-1]];
                    lead1 = LeadingCoefficient[top1];
                    lead2 = LeadingCoefficient[top2];
                    list1 = Map[(#/lead1)&,list1]; 
                    list2 = Map[(#/lead2)&,list2]; 
      ];
(*    
      Compare the expressions as lists of terms.
*)
      Return[NCGreater[list1,list2]]
];

(* 
    In this next piece of code, expr2 is converted into 
    a list of copies of expr2.

*)
NCGreater[expr1_Plus,expr2_,opts___] := 
Module[{list1,list2,len1,top1,top2,lead1,lead2,normalize},
      normalize = LeadingCoefficientOne/. {opts} /. Options[NCGreater];
(*
      Turn the sums into lists so that we can 
      sort them.
*)
      list1 = Apply[List,expr1];
      list1 = NCSort[list1];
      len1 = Length[list1];
      If[normalize,
(*
      Divide each expression by the coefficient 
      of the leading term of each expression.
*)
(* THEN *)          top1 = list1[[-1]];
                    top2 = expr2;
                    lead1 = LeadingCoefficient[top1];
                    lead2 = LeadingCoefficient[top2];
                    list1 = Map[(#/lead1)&,list1]; 
                    list2 = Table[top2/lead2,{j,1,len1}];,
(* ELSE *)          list2 = Map[expr2&,list1];
      ];
(*    
      Compare the expressions as lists of terms.
*)
      Return[NCGreater[list1,list2]]
];

LeadingCoefficient[c_?NumberQ x_] := c;
LeadingCoefficient[x_] := 1;

NCGreater[expr1_,expr2_Plus,opts___] :=  
       Not[NCGreater[expr2,expr1,opts]];

(*
                  PROCESSING OF LISTS 
*)
NCGreater[x_List,y_List,opts___] := 
     Which[x===y,       False
         , Length[x] > Length[y], True
         , Length[x] < Length[y], False
         , True, NCListGreater[x,y]
     ];

NCListGreater[{x___,y_,z___},{x___,v_,w___},opts___] := 
      NCGreater[y,v] /; Not[y===v]

(*
                  PROCESSING OF NONCOMMUTATIVEMULTIPLIES ** 
*)
NCGreater[c_. expr1_NonCommutativeMultiply,
          d_. expr1_NonCommutativeMultiply,opts___] :=  OrderedQ[{d,c}];

NCGreater[c_. expr1_NonCommutativeMultiply,
          d_. expr2_NonCommutativeMultiply,opts___] :=  
              NCGreater[Apply[List,expr1],
                        Apply[List,expr2]];

(*
     If both expression are commutative,
     use Mathematica's ordering.
*)
NCGreater[x_,y_,opts___] := OrderedQ[{y,x}] /; CommutativeAllQ[x] &&
                                               CommutativeAllQ[y]

(*
                  PROCESSING OF TIMES
*)
NCGreater[c_. x_System`NonCommutativeMultiply,
          d_. x_System`NonCommutativeMultiply,
          opts___] := OrderedQ[{d,c}];

NCGreater[c_. x_System`NonCommutativeMultiply,
          d_. y_System`NonCommutativeMultiply,
          opts___] := NCGreater[x,y];

(*
                  PROCESSING OF DUPLICATE HEADS
*)
(*
     If both expression are symbols,
     use Mathematica's ordering.
*)
NCGreater[c_. x_Symbol,
          d_. x_Symbol,
          opts___] := NCGreater[c,d];

NCGreater[c_. x_Symbol,
          d_. y_Symbol,
          opts___] := OrderedQ[{y,x}];

NCGreater[c_. x_Symbol,d_. y_?(MemberQ[HeadOrder,#])&,opts___] := False;
NCGreater[d_. y_?(MemberQ[HeadOrder,#])&,c_. x_Symbol,opts___] := False;

             
(*
     If both expression have the same head,
     use Mathematica's ordering.
     Note:  The following code will not execute if
     both of the heads are Plus or List, because these 
     cases were specified above.
*)
NCGreater[c_. (AHead_)[x___],
          d_. (AHead_)[x___],
          opts___] := NCGreater[c,d];

NCGreater[c_. (AHead_)[w___,x_,z___],
          d_. (AHead_)[w___,y_,z___],
          opts___] := NCGreater[x,y] /; Not[x===y];
(*
                  PROCESSING OF DIFFERENT HEADS
*)
(*
     Rt and Inv are used in the Mora's algorithm code.
*)
(*
    For example, tp[anything] is less than inv[anythingelse]
*)
HeadOrder = {System`Integer,
             System`Rational,
             System`Real,
             System`Complex,
             System`Times,
             Global`IdentityOf,
             System`Symbol,
             NonCommutativeMultiply`tp,
             Global`Tp,
             NonCommutativeMultiply`aj,
             Ajize`Aj,
             Global`Dyad,
             System`Power,
             Global`OperatorSignature,
             NonCommutativeMultiply`inv,
             Global`Inv,
             NonCommutativeMultiply`rt,
             Global`Rt,
             System`NonCommutativeMultiply
};

SetHeadOrder[x_] := HeadOrder = x;

WhatIsHeadOrder[] := HeadOrder;
(*
NCGreater[c_. x_,d_. y_,opts___] := 
       False /;   MemberQ[HeadOrder,y];

NCGreater[d_. y_?(MemberQ[HeadOrder,#])&,c_. x_,opts___] := 
       True /;   MemberQ[HeadOrder,y];
*)
NCGreater[c_. x_,d_. y_,opts___] := 
Module[{a,b},
    a = Flatten[Position[HeadOrder,Head[x]]]; 
    b = Flatten[Position[HeadOrder,Head[y]]];
    Return[Greater[a[[1]],
                   b[[1]]]
          ]
] /;   MemberQ[HeadOrder,Head[x]] && 
       MemberQ[HeadOrder,Head[y]] &&
       Not[Head[x]===Head[y]]
        
(*
                  PROCESSING OF UNKNOWNS
*)
NCGreater[x_,y_,opts___] := NCGreater[x,y,opts] = 
Module[{comparison},
     comparison = "unknown";
     While[comparison === "unknown",
              Print["NCGreater cannot figure out if"];
              Print[x," is greater than ",y,".\n"];       
              Print["Is it?"];
              comparison = Input["(True or False)"];

     ];
     Return[comparison]
];
     
NCGreater[x___] :=  BadCall["NCGreater",x];

End[];
EndPackage[]

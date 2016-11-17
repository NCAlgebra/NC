(* This is a test file created after bug3 which stopped at iteration 3 cleaning  basis 5007. It was a integer overflow bug that got fixed in July 2009 by plugging in GNU GMP. *)

(*
  SetMonomialOrder[{
   A, B, tpA, tpB, pinvA, pinvB, pinvtpA, 
   pinvtpB, tppinvA, tppinvB, 
   Pinv[A ** pinvA + pinvB ** B], 
   Pinv[Tp[A ** pinvA + pinvB ** B]], 
   Tp[Pinv[A ** pinvA + pinvB ** B]],
   Pinv[A ** pinvA - pinvB ** B ** A ** pinvA], 
   Pinv[Tp[A ** pinvA - pinvB ** B ** A ** pinvA]], 
   Tp[Pinv[A ** pinvA - pinvB ** B ** A ** pinvA]],
   Pinv[tpB ** tppinvB + tppinvA ** tpA],
   Pinv[tppinvA ** tpA - tppinvA ** tpA ** tpB ** tppinvB]
 }]
*)

SetNonCommutative[
   A, B, tpA, tpB, pinvA, pinvB, pinvtpA, 
   pinvtpB, tppinvA, tppinvB, 
   rat1, 
   (* rat2, *)
   tprat1,
   rat3, 
   (* rat4, *)
   tprat3,
   rat5,
   rat6
 ]
SetMonomialOrder[{
   A, B, tpA, tpB, pinvA, pinvB, pinvtpA, 
   pinvtpB, tppinvA, tppinvB, 
   rat1, 
   (* rat2, *)
   tprat1,
   rat3, 
   (* rat4, *)
   tprat3,
   rat5,
   rat6
 }]

rels= {A ** pinvA ** A - A, 
       pinvA ** A ** pinvA - pinvA, 
       tpA ** tppinvA - pinvA ** A, 
       tppinvA ** tpA - A ** pinvA, 
       tppinvA - pinvtpA, 
       B ** pinvB ** B - B, 
       pinvB ** B ** pinvB - pinvB, 
       tpB ** tppinvB - pinvB ** B, 
       tppinvB ** tpB - B ** pinvB, 
       tppinvB - pinvtpB, 
       (A ** pinvA + pinvB ** B) ** rat1 ** (A ** pinvA + pinvB ** B) - A ** pinvA + pinvB ** B, 
       rat1 ** (A ** pinvA + pinvB ** B) ** rat1 - rat1, 
       (tpB ** tppinvB + tppinvA ** tpA) ** tprat1 - rat1 ** (A ** pinvA + pinvB ** B), 
       tprat1 ** (tpB ** tppinvB + tppinvA ** tpA) - (A ** pinvA + pinvB ** B) ** rat1, 
       tprat1 - rat5, 
       (A ** pinvA - pinvB ** B ** A ** pinvA) ** rat3 ** (A ** pinvA - pinvB ** B ** A ** pinvA) - (A ** pinvA - pinvB ** B ** A ** pinvA), 
       rat3 ** (A ** pinvA - pinvB ** B ** A ** pinvA) ** rat3 - rat3, 
       (tppinvA ** tpA - tppinvA ** tpA ** tpB ** tppinvB) ** tprat3 - rat3 ** (A ** pinvA - pinvB ** B ** A ** pinvA), 
       tprat3 ** (tppinvA ** tpA - tppinvA ** tpA ** tpB ** tppinvB) - (A ** pinvA - pinvB ** B ** A ** pinvA) ** rat3, 
       tprat3 - rat6}

Iterations=5;

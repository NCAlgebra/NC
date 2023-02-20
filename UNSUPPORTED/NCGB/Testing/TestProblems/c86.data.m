(* This is a test file created after bug3 which stopped at iteration 3 cleaning  basis 5007. It was a integer overflow bug that got fixed in July 2009 by plugging in GNU GMP. *)

SetMonomialOrder[{
   A, B, Tp[A], Tp[B], Pinv[A], Pinv[B], Pinv[Tp[A]], 
   Pinv[Tp[B]], Tp[Pinv[A]], Tp[Pinv[B]], 
   Pinv[A ** Pinv[A] + Pinv[B] ** B], 
   Pinv[Tp[A ** Pinv[A] + Pinv[B] ** B]], 
   Tp[Pinv[A ** Pinv[A] + Pinv[B] ** B]],
   Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]], 
   Pinv[Tp[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]]], 
   Tp[Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]]],
   Pinv[Tp[B] ** Tp[Pinv[B]] + Tp[Pinv[A]] ** Tp[A]],
   Pinv[Tp[Pinv[A]] ** Tp[A] - Tp[Pinv[A]] ** Tp[A] ** Tp[B] ** Tp[Pinv[B]]]
 }]

rels= {A ** Pinv[A] ** A == A, Pinv[A] ** A ** Pinv[A] == Pinv[A], Tp[A] ** Tp[Pinv[A]] == Pinv[A] ** A, 
    Tp[Pinv[A]] ** Tp[A] == A ** Pinv[A], Tp[Pinv[A]] == Pinv[Tp[A]], B ** Pinv[B] ** B == B, 
    Pinv[B] ** B ** Pinv[B] == Pinv[B], Tp[B] ** Tp[Pinv[B]] == Pinv[B] ** B, Tp[Pinv[B]] ** Tp[B] == B ** Pinv[B], 
    Tp[Pinv[B]] == Pinv[Tp[B]], (A ** Pinv[A] + Pinv[B] ** B) ** Pinv[A ** Pinv[A] + Pinv[B] ** B] ** 
      (A ** Pinv[A] + Pinv[B] ** B) == A ** Pinv[A] + Pinv[B] ** B, 
   Pinv[A ** Pinv[A] + Pinv[B] ** B] ** (A ** Pinv[A] + Pinv[B] ** B) ** Pinv[A ** Pinv[A] + Pinv[B] ** B] == 
    Pinv[A ** Pinv[A] + Pinv[B] ** B], (Tp[B] ** Tp[Pinv[B]] + Tp[Pinv[A]] ** Tp[A]) ** 
     Tp[Pinv[A ** Pinv[A] + Pinv[B] ** B]] == Pinv[A ** Pinv[A] + Pinv[B] ** B] ** (A ** Pinv[A] + Pinv[B] ** B), 
    Tp[Pinv[A ** Pinv[A] + Pinv[B] ** B]] ** (Tp[B] ** Tp[Pinv[B]] + Tp[Pinv[A]] ** Tp[A]) == 
     (A ** Pinv[A] + Pinv[B] ** B) ** Pinv[A ** Pinv[A] + Pinv[B] ** B], 
   Tp[Pinv[A ** Pinv[A] + Pinv[B] ** B]] == Pinv[Tp[B] ** Tp[Pinv[B]] + Tp[Pinv[A]] ** Tp[A]], 
    (A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]) ** Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]] ** 
      (A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]) == A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A], 
   Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]] ** (A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]) ** 
      Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]] == Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]], 
    (Tp[Pinv[A]] ** Tp[A] - Tp[Pinv[A]] ** Tp[A] ** Tp[B] ** Tp[Pinv[B]]) ** 
      Tp[Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]]] == 
     Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]] ** (A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]), 
    Tp[Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]]] ** 
      (Tp[Pinv[A]] ** Tp[A] - Tp[Pinv[A]] ** Tp[A] ** Tp[B] ** Tp[Pinv[B]]) == 
     (A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]) ** Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]], 
    Tp[Pinv[A ** Pinv[A] - Pinv[B] ** B ** A ** Pinv[A]]] == 
       Pinv[Tp[Pinv[A]] ** Tp[A] - Tp[Pinv[A]] ** Tp[A] ** Tp[B] ** Tp[Pinv[B]]]}

Iterations=3;

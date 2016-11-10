# Most Basic Commands {#MostBasicCommands}

This chapter provides a gentle introduction to some of the commands
available in `NCAlgebra`. Before you can use `NCAlgebra` you first
load it with the following commands:

    In[1]:= << NC`
    In[2]:= << NCAlgebra`

## To Commute Or Not To Commute?

In `NCAlgebra`, the operator `**` denotes *noncommutative
multiplication*.

At present, single-letter lower case variables are noncommutative by
default and all others are commutative by default.

We consider non-commutative lower case variables in the following
examples:

    In[3]:= a**b-b**a
    Out[3]= a**b-b**a
    In[4]:= A**B-B**A
    Out[4]= 0
    In[5]:= A**b-b**A
    Out[5]= 0

One of Bill's favorite commands is `CommuteEverything`, which
temporarily makes all noncommutative symbols appearing in a given
expression to behave as if they were commutative and returns the
resulting commutative expression:

    In[6]:= CommuteEverything[a**b-b**a]
    Out[6]= 0
    In[7]:= EndCommuteEverything[]
    In[8]:= a**b-b**a
    Out[8]= a**b-b**a

`EndCommuteEverything` restores the original noncommutative behavior.

`SetNonCommutative` can make any symbol behave as noncommutative:

    In[9]:= SetNonCommutative[A,B]
    In[10]:= A**B-B**A
    Out[10]= A**B-B**A
    In[11]:= SetNonCommutative[A]; SetCommutative[B];
    In[12]:= A**B-B**A
    Out[12]= 0
    
`SNC` is an alias for `SetNonCommutative`. So, `SNC` can be typed rather than the longer `SetNonCommutative`.

    In[13]:= SNC[A];
    In[14]:= A**a-a**A
    Out[14]= -a**A+A**a

`SetCommutative` makes symbols behave as commutative:

    In[15]:= SetCommutative[v];
    In[16]:= v**b
    Out[16]= b v

## Inverses

The multiplicative identity is denoted `Id` in the program. At the
present time, `Id` is set to 1.

A symbol `a` may have an inverse, which will be denoted by
`inv[a]`. For example:

    In[17]:= Id
    Out[17]= 1
    In[18]:= inv[a**b]
    Out[18]= inv[a**b]
    In[19]:= inv[a]**a
    Out[19]= 1
    In[20]:= a**inv[a]
    Out[20]= 1
    In[21]:= a**b**inv[b]
    Out[21]= a

## Transposes and Adjoints

`tp[x]` denotes the transpose of symbol `x`

`aj[x]` denotes the adjoint of symbol `x`
   
The properties of transposes and adjoints that everyone uses
constantly are built-in. For example:

    In[22]:= tp[a**b]
    Out[22]= tp[b]**tp[a]
    In[23]:= tp[5]
    Out[23]= 5
    In[24]:= tp[2+3I]   (* I is the imaginary unit *)
    Out[24]= 2+3 I
    In[25]:= tp[a]
    Out[25]= tp[a]
    In[26]:= tp[a+b]
    Out[26]= tp[a]+tp[b]
    In[27]:= tp[6x]
    Out[27]= 6 tp[x]
    In[28]:= tp[tp[a]]
    Out[28]= a
	
For `aj`:

    In[29]:= aj[5]
    Out[29]= 5
    In[30]:= aj[2+3I]
    Out[30]= 2-3 I
    In[31]:= aj[a]
    Out[31]= aj[a]
    In[32]:= aj[a+b]
    Out[32]= aj[a]+aj[b]
    In[33]:= aj[6x]
    Out[33]= 6 aj[x]
    In[34]:= aj[aj[a]]
    Out[34]= a

Since v.5.0 transposes and adjoints in a notebook environment render
as $x^T$ and $x^*$.

## Expand and Collect

One can collect noncommutative terms involving same powers of a symbol
using `NCCollect`. There is also a stronger version of collect called
`NCStrongCollect`. `NCCollect` groups terms by degree before
collecting and `NCStrongCollect` does not. As a result,
`NCStrongCollect` often collects more than one would normally expect.

`NCExpand` expands noncommutative products.

For example:

    In[35]:= NCExpand[(a+b)**x]
    Out[35]= a**x+b**x
    In[36]:= NCCollect[a**x+b**x,x]
    Out[36]= (a+b)**x
    In[37]:= NCCollect[tp[x]**a**x+tp[x]**b**x+z,{x,tp[x]}]
    Out[37]= z+tp[x]**(a+b)**x
	
## Replace

The Mathematica substitute commands, e.g. `ReplaceAll` (`/.`) and
`ReplaceRepeated` (`//.`), are not reliable in `NCAlgebra`, so you
must use our `NC` versions of these commands:

    In[38]:= NCReplaceAll[x**a**b,a**b->c]
    Out[38]= x**a**b
    In[39]:= NCReplaceAll[tp[a]**tp[b]+b**a,b**a->p]
    Out[39]= p+tp[a]**tp[b]

USe [NCMakeRuleSymmetric](#NCMakeRuleSymmetric) and
[NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint) to automatically
create symmetric and self adjoint versions of your rules:

    In[40]:= NCReplaceAll[tp[a**b]+w+a**b,a**b->c]
    Out[40]= c+w+tp[b]**tp[a]
    In[41]:= NCReplaceAll[tp[a**b]+w+a**b,NCMakeRuleSymmetric[a**b->c]]
    Out[41]= c+w+tp[c]

## Rationals and Simplification

`NCSimplifyRational` attempts to simplify noncommutative rationals.

    In[42]:= f1=1+inv[d]**c**inv[S-a]**b-inv[d]**c**inv[S-a+b**inv[d]**c]**b\
             -inv[d]**c**inv[S-a+b**inv[d]**c]**b**inv[d]**c**inv[S-a]**b
    Out[42]= 1+inv[d]**c**inv[-a+S]**b-inv[d]**c**inv[-a+S+b**inv[d]**c]**b\
             -inv[d]**c**inv[-a+S+b**inv[d]**c]**b**inv[d]**c**inv[-a+S]**b
    In[43]:= NCSimplifyRational[f1]
    Out[43]= 1
    In[44]:= f2=2inv[1+2a]**a;
    In[45]:= NCSimplifyRational[f2]
    Out[45]= 1-inv[1+2 a]

`NCSR` is the alias for `NCSimplifyRational`.

    In[46]:= f3=a**inv[1-a];
    In[47]:= NCSR[f3]
    Out[47]= -1+inv[1-a]
    In[48]:= f4=inv[1-b**a]**inv[a];
    In[49]:= NCSR[f4]
    Out[49]= inv[a]+b**inv[1-b**a]

## Calculus

One can calculate directional derivatives with `DirectionalD` and
noncommutative gradients with `NCGrad`.

    In[50]:= DirectionalD[x**x,x,h]
    Out[50]= h**x+x**h
    In[51]:= NCGrad[tp[x]**x+tp[x]**A**x+m**x,x]
    Out[51]= m+tp[x]**A+tp[x]**tp[A]+2 tp[x]

?? ADD INTEGRATE AND HESSIAN ??

## Matrices

`NCAlgebra` has many algorithms that handle matrices with
noncommutative entries.

    In[52]:= m1={{a,b},{c,d}}
    Out[52]= {{a,b},{c,d}}
    In[53]:= m2={{d,2},{e,3}}
    Out[53]= {{d,2},{e,3}}
    In[54]:= MatMult[m1,m2]
    Out[54]= {{a**d+b**e,2 a+3 b},{c**d+d**e,2 c+3 d}}

?? ADD NCInverse, and much more ??

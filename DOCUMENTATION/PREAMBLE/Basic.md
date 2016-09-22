# Most Basic Commands {#MostBasicCommands}

First you must load in NCAlgebra with the following command 

    In[1]:= <<NC`
    In[2]:= <<NCAlgebra`

## To Commute Or Not To Commute?

In `NCAlgebra`, the operator `**` denotes *noncommutative multiplication*.

At present, single-letter lower case variables are non-commutative by default and all others are commutative by default.

We consider non-commutative lower case variables in the following examples:

    In[3]:= a**b-b**a
    Out[3]= a**b-b**a
    In[4]:= A**B-B**A
    Out[4]= 0
    In[5]:= A**b-b**A
    Out[5]= 0

`CommuteEverything` temporarily makes all noncommutative symbols appearing in a given expression to behave as if they were commutative and returns the resulting commutative expression:

    In[6]:= CommuteEverything[a**b-b**a]
    Out[6]= 0
    In[7]:= EndCommuteEverything[]
    In[8]:= a**b-b**a
    Out[8]= a**b-b**a

`EndCommuteEverything` restores the original noncommutative behavior.

`SetNonCommutative` makes symbols behave permanently as noncommutative:

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

`SetCommutative` makes symbols permanently behave as commutative:

    In[15]:= SetCommutative[v];
    In[16]:= v**b
    Out[16]= b v

## Transposes and Adjoints

`tp[x]` denotes the transpose of an element `x`

`aj[x]` denotes the adjoint of an element `x`
   
The properties of transposes and adjoints that everyone uses constantly are built-in: 

    In[17]:= tp[a**b]
    Out[17]= tp[b]**tp[a]
    In[18]:= tp[5]
    Out[18]= 5
    In[19]:= tp[2+3I]   (* I is the imaginary unit *)
    Out[19]= 2+3 I
    In[20]:= tp[a]
    Out[20]= tp[a]
    In[21]:= tp[a+b]
    Out[21]= tp[a]+tp[b]
    In[22]:= tp[6x]
    Out[22]= 6 tp[x]
    In[23]:= tp[tp[a]]
    Out[23]= a
    In[24]:= aj[5]
    Out[24]= 5
    In[25]:= aj[2+3I]
    Out[25]= 2-3 I
    In[26]:= aj[a]
    Out[26]= aj[a]
    In[27]:= aj[a+b]
    Out[27]= aj[a]+aj[b]
    In[28]:= aj[6x]
    Out[28]= 6 aj[x]
    In[29]:= aj[aj[a]]
    Out[29]= a

## Inverses

The multiplicative identity is denoted `Id` in the program. At the present time, `Id` is set to 1.

A symbol `a` may have an inverse, which will be denoted by `inv[a]`.

    In[30]:= Id
    Out[30]= 1
    In[31]:= inv[a**b]
    Out[31]= inv[a**b]
    In[32]:= inv[a]**a
    Out[32]= 1
    In[33]:= a**inv[a]
    Out[33]= 1
    In[34]:= a**b**inv[b]
    Out[34]= a

## Expand and Collect

    In[35]:= NCExpand[(a+b)**x]
    Out[35]= a**x+b**x
    In[36]:= NCCollect[a**x+b**x,x]
    Out[36]= (a+b)**x
    In[37]:= NCCollect[tp[x]**a**x+tp[x]**b**x+z,{x,tp[x]}]
    Out[37]= z+tp[x]**(a+b)**x

## Replace

The Mathematica substitute commands, e.g. `Replace`, `ReplaceAll` (`/.`) and `ReplaceRepeated` (`//.`), are not reliable in `NCAlgebra`,  so you must use our `NC` versions of these commands:

    In[38]:= NCReplace[x**a**b,a**b->c]
    Out[38]= x**a**b
    In[39]:= NCReplaceAll[tp[b**a]+b**a,b**a->p]
    Out[39]= p+tp[a]**tp[b]

USe [NCMakeRuleSymmetric](#NCMakeRuleSymmetric) and [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint) to automatically create symmetric and self adjoint versions of your rules:

    In[40]:= NCReplaceAll[tp[a**b]+w+a**b,a**b->c]
    Out[40]= c+w+tp[b]**tp[a]
    In[41]:= NCReplaceAll[tp[a**b]+w+a**b,NCMakeRuleSymmetric[a**b->c]]
    Out[41]= c+w+tp[c]

## Rationals and Simplification

    In[42]:= f1=1+inv[d]**c**inv[S-a]**b-inv[d]**c**inv[S-a+b**inv[d]**c]**b-inv[d]**c**inv[S-a+b**inv[d]**c]**b**inv[d]**c**inv[S-a]**b
    Out[42]= 1+inv[d]**c**inv[-a+S]**b-inv[d]**c**inv[-a+S+b**inv[d]**c]**b-inv[d]**c**inv[-a+S+b**inv[d]**c]**b**inv[d]**c**inv[-a+S]**b
    In[43]:= NCSimplifyRational[f1]
    Out[43]= 1
    In[44]:= f2= 2inv[1+2a]**a;
    In[45]:= NCSimplifyRational[f2]
    Out[45]= 1-inv[1+2 a]

**NOTE:** `NCSR` is the alias for `NCSimplifyRational`.

    In[46]:= f3=a**inv[1-a];
    In[47]:= NCSR[f3]
    Out[47]= -1+inv[1-a]
    In[48]:= f4=inv[1-b**a]**inv[a];
    In[49]:= NCSR[f4]
    Out[49]= inv[a]+b**inv[1-b**a]

## Calculus

    In[50]:= DirectionalD[x**x,x,h]
    Out[50]= h**x+x**h
    In[51]:= NCGrad[tp[x]**x+tp[x]**A**x+m**x,x]
    Out[51]= m+tp[x]**A+tp[x]**tp[A]+2 tp[x]

## Matrices

    In[52]:= m1={{a,b},{c,d}}
    Out[52]= {{a,b},{c,d}}
    In[53]:= m2={{d,2},{e,3}}
    Out[53]= {{d,2},{e,3}}
    In[54]:= MatMult[m1,m2]
    Out[54]= {{a**d+b**e,2 a+3 b},{c**d+d**e,2 c+3 d}}

(module tests mzscheme
  (provide nums)
  (provide str)
  (provide trueFalse)
  (provide list)
  (provide zero)
  (provide null)
  (provide bool)
  (provide math)
  (provide let)
  (provide inequal)
  (provide if)
  (provide while)
  (provide complex)

  ;;;;;;;;;;;;;;;; tests ;;;;;;;;;;;;;;;;

  
  (define nums
     '("{
         {
           nlog '# BASIC NUMBERS:';
           nlog '# log 1;';
           nlog '#   expected outcome: 1';
           nlog '#   actual outcome:   ';
           log 1;
           nlog '#';

           nlog '# log -5;';
           nlog '#   expected outcome: -5';
           nlog '#   actual outcome:   ';
           log -5;
           nlog '#'
          }
         }"))

  (define str
    '("{
         {
           nlog '# BASIC STRINGS:';
           nlog '# abc';
           nlog '#   expected outcome: # abc';
           nlog '#   actual outcome:   ';
           log '# abc';
           nlog '#';

           nlog '# This is great! ;) Really? No, not really :(' ;
           nlog '#   expected outcome: # This is great! ;) Really? No, not really :(';
           nlog '#   actual outcome:   ';
           log '# This is great! ;) Really? No, not really :(' ;
           nlog '#'
          }
         }"))

  (define trueFalse
    '("{
         {
           nlog '# TRUE/FALSE:';
           nlog '# True   ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           log True;
           nlog '#';

           nlog '# False   ';
           nlog '#   expected outcome: #f';
           nlog '#   actual outcome:   ';
           log False;
           nlog '#'
          }
         }"))

  (define list
    '("{
         {
           nlog '# LISTS:';
           nlog '# [1,2,3,4,5]   ';
           nlog '#   expected outcome: (1 2 3 4 5)';
           nlog '#   actual outcome:   ';
           log [1,2,3,4,5];
           nlog '#';

           nlog '# emptyList   ';
           nlog '#   expected outcome: ()';
           nlog '#   actual outcome:   ';
           log emptyList;
           nlog '#'
          }
         }"))

  (define zero
    '("{
         {
           nlog '# ISZERO?:';
           nlog '# isZero?(0) ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           log isZero?(0);
           nlog '#';

           nlog '# isZero?(1)  ';
           nlog '#   expected outcome: #f';
           nlog '#   actual outcome:   ';
           log isZero?(1);
           nlog '#'
          }
         }"))

  (define null
    '("{
         {
           nlog '# ISNULL?:';
           nlog '# isNull?([1])   ';
           nlog '#   expected outcome: #f';
           nlog '#   actual outcome:   ';
           log isNull?([1]);
           nlog '#';

           nlog '# isNull?(emptyList)   ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           log isNull?(emptyList);
           nlog '#'
          }
         }"))

  (define bool
    '("{
        {
           nlog '# BOOLEAN OPERATIONS:';
           nlog '# ||(isZero?(1), isNull?(emptyList))   ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           log ||(isZero?(1), isNull?(emptyList));
           nlog '#';

           nlog '# &&(isZero?(0), True)   ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           log &&(isZero?(0), True);
           nlog '#';

           nlog '# &&(isZero?(0), !(False)   ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           log &&(isZero?(0), !(False));
           nlog '#';

           nlog '# !(isNull?([1,2,3]))   ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           log !(isNull?([1,2,3]));
           nlog '#'
          }
         }"))

  (define math
    '("{
        {
           nlog '# MATH OPERATIONS:';
           nlog '# sub(7,4)   ';
           nlog '#   expected outcome: 3';
           nlog '#   actual outcome:   ';
           log sub(7,4);
           nlog '#';

           nlog '# div(7,4)   ';
           nlog '#   expected outcome: 7/4';
           nlog '#   actual outcome:   ';
           log div(7,4);
           nlog '#';

           nlog '# intDiv(7,4)   ';
           nlog '#   expected outcome: 1';
           nlog '#   actual outcome:   ';
           log intDiv(7,4);
           nlog '#'
          }
         }"))

  (define let
    '("{
         {
           nlog '# LET/PROC:';
           nlog '# set _x = 8; set _i = 3; set _v = div(_x,_i);   ';
           nlog '#   expected outcome: 8/3';
           nlog '#   actual outcome:   ';
           set _x = 8;
           set _i = 3;
           set _v = div(_x,_i);
           log _v;
           nlog '#';

           nlog '# set _i = proc _y =>{ sub(_y,5)};   ';
           nlog '# set _v = proc _z =>{ div(-> _i(25),_z)};   ';
           set _i =
               proc _y =>
               { sub(_y,5)};

           set _v =
               proc _z =>
               { div(-> _i(25),_z)};

           nlog '# -> _i(40)   ';
           nlog '#   expected outcome: 35';
           nlog '#   actual outcome:   ';
           log -> _i(40);
           nlog '#';

           nlog '# -> _i(10)   ';
           nlog '#   expected outcome: 5';
           nlog '#   actual outcome:   ';
           log -> _i(10);
           nlog '#';

           nlog '# -> _v(2)   ';
           nlog '#   expected outcome: 10';
           nlog '#   actual outcome:   ';
           log -> _v(2);
           nlog '#';
           
           nlog '# set _x = 5; sub(20, sub(_x,4))   ';
           nlog '#   expected outcome: 19';
           nlog '#   actual outcome:   ';
           set _x = 5;
           log sub(20, sub(_x,4));
           nlog '#';

           nlog '# set _i = proc _y => {sub(_y,5)};';
           nlog '# set _v = proc _z => { proc _a => {div(-> _i(_z),_a)};log -> -> _v(6)(10);';
           nlog '#   expected outcome: 1/10';
           nlog '#   actual outcome:   ';
           set _i =
               proc _y =>
               { sub(_y,5)};

           set _v =
               proc _z =>
                    { proc _a => { div(-> _i(_z),_a)} };
           log -> -> _v(6)(10);
           nlog '#';

           nlog '# let _a, _b, _c in {let _a = 6; set _b = 4; set _c = 13; nlog intDiv(_c, sub(_a, _b))}';
           nlog '#   expected outcome: 6';
           nlog '#   actual outcome:   ';

           let _a, _b, _c in {
           set _a = 6;
           set _b = 4;
           set _c = 13;
           log intDiv(_c, sub(_a, _b))}
          }
         }"))

  (define inequal
    '("{
         {
           nlog '# INEQUALITY OPERATIONS:';
           nlog '# set _x = 5; set _i = 4; >(_x, _i)   ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           set _x = 5;
           set _i = 4;
           log >(_x, _i);
           nlog '#';

           nlog '# set _x = 5; set _i = 7; >=(_x, _i)   ';
           nlog '#   expected outcome: #f';
           nlog '#   actual outcome:   ';
           set _x = 5;
           set _i = 7;
           log >=(_x, _i);
           nlog '#';

           nlog '# set _x = 5; set _i = 3; <(_x, _i)   ';
           nlog '#   expected outcome: #f';
           nlog '#   actual outcome:   ';
           set _x = 5;
           set _i = 3;
           log <(_x, _i);
           nlog '#';

           nlog '# set _x = 9; set _i = 9; <=(_x, _i)   ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           set _x = 9;
           set _i = 9;
           log <=(_x, _i);
           nlog '#';

           nlog '# set _x = 5; set _i = 5; ==(_x, _i)   ';
           nlog '#   expected outcome: #t';
           nlog '#   actual outcome:   ';
           set _x = 5;
           set _i = 5;
           log ==(_x, _i);
           nlog '#';

           nlog '# set _x = 7; set _i = 7; !=(_x, _i)   ';
           nlog '#   expected outcome: #f';
           nlog '#   actual outcome:   ';
           set _x = 7;
           set _i = 7;
           log !=(_x, _i);
           nlog '#'
          }
        }"))

  (define if
    '("{
          {
           nlog '# IF AND IFF OPERATIONS:';
           nlog '# set _x = 3; set _i = 3; if ==(_x, _i) {log # they are equal}else{log # they are not equal}   ';
           nlog '#   expected outcome: # they are equal';
           nlog '#   actual outcome:   ';
           set _x = 3;
           set _i = 3;
           if ==(_x,_i)
           {
               log '# they are equal'
           }
           else
           {
               log '# they are not equal'
           };
           nlog '#';

           nlog '# set _x = 4; set _i = 3; if ==(_x, _i) {log # they are equal}else{log # they are not equal}   ';
           nlog '#   expected outcome: # they are not equal';
           nlog '#   actual outcome:   ';
           set _x = 4;
           set _i = 3;
           if ==(_x,_i)
           {
               log '# they are equal'
           }
           else
           {
               log '# they are not equal'
           };
           nlog '#';

           nlog '# iff isNull?(emptyList){ log 5 }   ';
           nlog '#   expected outcome: 5';
           nlog '#   actual outcome:   ';
           iff isNull?(emptyList)
              { log 5 };
           nlog '#';

           nlog '# iff isNull?([1,2]){ log 5 }   ';
           nlog '#   expected outcome: ';
           nlog '#   actual outcome:   ';
           iff isNull?([1,2])
              { log 5 };
           nlog '#';

           nlog '# iff isNull?([1,2]){ log 5 } elif isNull?([1,2]) { log 0 };   ';
           nlog '#   expected outcome: ';
           nlog '#   actual outcome:   ';
           iff isNull?([1,2])
               { log 5 }
           elif isNull?([1,2])
               { log 0 };
           nlog '#';

           nlog '# iff isNull?([1,2]){ log 5 } elif isNull?(emptyList) { log 0 };   ';
           nlog '#   expected outcome: 0';
           nlog '#   actual outcome:   ';
           iff isNull?([1,2])
               { log 5 }
           elif isNull?(emptyList)
               { log 0 };
           nlog '#';

           nlog '# if isNull?(emptyList){ log 1 } else{ log -1 };   ';
           nlog '#   expected outcome: 1';
           nlog '#   actual outcome:   ';
           if isNull?(emptyList)
               { log 1 }
           else
               { log -1 };
           nlog '#';

           nlog '# if isNull?([1,2]){ log 1 } else{ log -1 };   ';
           nlog '#   expected outcome: -1';
           nlog '#   actual outcome:   ';
           if isNull?([1,2])
               { log 1 }
           else
               { log -1 };
           nlog '#';

           nlog '# if isNull?([1,2]){ log 1 } elif isNull?(emptyList){ log 0 } else{ log -1 };   ';
           nlog '#   expected outcome: 0';
           nlog '#   actual outcome:   ';
           if isNull?([1,2])
              { log 1 }
           elif isNull?(emptyList)
              { log 0 }
           else
              { log -1 };
           nlog '#';

           nlog '# if isNull?([1,2]){ log 1 } elif isNull?([1,2]){ log 0 } else{ log -1 };   ';
           nlog '#   expected outcome: -1';
           nlog '#   actual outcome:   ';
           if isNull?([1,2])
              { log 1 }
           elif isNull?([1,2])
              { log 0 }
           else
              { log -1 };
           nlog '#';


           nlog '# set _x = 12; set _i = 15; if >(_x, _i) {log _x} elif <(_x, _i){log i} else {log 0}   ';
           nlog '#   expected outcome: 15';
           nlog '#   actual outcome:   ';
           set _x = 12;
           set _i = 15;

           if >(_x,_i)
           {
               log _x
           }
           elif <(_x, _i)
           {
              log _i
           }
           else
           {
               log 0
           };
           nlog '#';

           nlog '# if isNull?([1]){ log 3 } elif isNull?([1,2]){ log 2 } elif isNull?([1,2,3]){ log 1 } elif !(isNull?([1,2,3,4])){ log 0 }else{ log -1 };   ';
           nlog '#   expected outcome: 0';
           nlog '#   actual outcome:   ';
           if isNull?([1])
              { log 3 }
           elif isNull?([1,2])
              { log 2 }
           elif isNull?([1,2,3])
              { log 1 }
           elif !(isNull?([1,2,3,4]))
              { log 0 }
           else
              { log -1 };
           nlog '#'
          }
         }"))

  (define while
    '("{
        {
           nlog '# WHILE LOOP:';
           nlog '# set _x = -4; while !(isZero?(_x)){{ nlog _x; set _x = sub(_x, -1) }}   ';
           nlog '#   expected outcome: -4 -3 -2 -1 (on their own lines)';
           nlog '#   actual outcome:   ';
           set _x = -4;
           while !(isZero?(_x))
           {
             {
               nlog _x;
               set _x = sub(_x,-1)  
              }
           }
          }
         }"))

  (define complex
    '("{
         {
           nlog '# COMPLEX PROGRAM THAT USES MANY OF THE FEATURES:';
           nlog '# Please see tests.scm for the code   ';
           nlog '#   expected outcome: # _a is within 3 digits of _b';
           nlog '#   actual outcome:   ';

           let _a, _b, _c, _d in
           {   \\start of multi-stmt within n-let
               set _a = 3;
               set _b = 5;
               set _c = 0;
               while !(isZero?(_b))
               {  \\start of while
                 {  \\start of multi-stmt within while
                   iff >(_a, _b)
                   {    \\start of iff
                      set _c = sub(_c, -1)
                   };    \\end of iff
                   set _b = sub(_b,1)
                 }    \\end of multi-stmt
                };   \\end of while
 
               set _d = 
                    proc _z =>
                          {   \\start of proc
                           <=(_z, 3)
                          };   \\end of proc
                if -> _d (_c)
                {   \\start of if
                   log '# _a is within 3 digits of _b'
                }   \\end of if
                else
                {   \\start of else
                   log '# _a was not within 3 digits of _b'
                }   \\end of else 
              }    \\end of let mult-stmt
             }   \\end of the mult-stmt for complex
          }  \\end of program for complex"))

  )
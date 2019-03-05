#!/bin/bash

if (($# != 1))
then
    echo "expecting size parameter!"
    exit 1
fi

if (($1 <= 1))
then
    echo "expecting size parameter > 1!"
    exit 1
fi

SIZE=$1

echo "; size parameter: $SIZE" 1>&2
#echo "(set-logic SAT)"

BOUND=`echo "scale=2; $SIZE + 1" | bc`	
CURINDEX=0
for ((;$CURINDEX<$BOUND;((CURINDEX++))))
do
    echo "(declare-const x$CURINDEX Int)"
done

echo "(define-fun P ((x Int)) Bool (>= x 0))"

echo "(define-fun and0 () Bool (and (P x0) (P x1)))"
#echo "(and (P(x0)) (P(x1)))"

#echo "(assert (P x0))"

#exit 1

CURINDEX=1
for ((;$CURINDEX<$SIZE;((CURINDEX++))))
do
    PREVINDEX=`echo "scale=2; $CURINDEX - 1" | bc`	
    NEXTINDEX=`echo "scale=2; $CURINDEX + 1" | bc`	
#    echo "(define-fun and$CURINDEX () Bool (and and$PREVINDEX x$NEXTINDEX) )"

    echo "(define-fun and$CURINDEX () Bool (and and$PREVINDEX (P x$NEXTINDEX)))"
done

echo "(assert and$CURINDEX)"
#TODO ADD ASSERTION 

echo "(check-sat)"


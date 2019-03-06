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
for ((;$CURINDEX<=$BOUND;((CURINDEX++))))
do
    echo "(declare-const x$CURINDEX Int)"
done

#echo "(define-fun P ((x Int)) Bool (>= x 0))"
echo "(define-fun P ((x Int) (y Int)) Bool (>= x y))"

echo "(define-fun or0 () Bool (or (P x0 x1) (P x1 x2)))"

#echo "(and (P(x0)) (P(x1)))"

#echo "(assert (P x0))"

#exit 1

CURINDEX=1
for ((;$CURINDEX<$SIZE;((CURINDEX++))))
do
    PREVINDEX=`echo "scale=2; $CURINDEX - 1" | bc`	
    NEXTINDEX1=`echo "scale=2; $CURINDEX + 1" | bc`
    NEXTINDEX2=`echo "scale=2; $CURINDEX + 2" | bc`	
#    echo "(define-fun and$CURINDEX () Bool (and and$PREVINDEX x$NEXTINDEX) )"

    TOGGLE=`echo "scale=0; $CURINDEX % 2" | bc`
    #echo "toggle $TOGGLE"
    if (($TOGGLE))
    then
	echo "(define-fun and$CURINDEX () Bool (and or$PREVINDEX (P x$NEXTINDEX1 x$NEXTINDEX2)))"
    else
	echo "(define-fun or$CURINDEX () Bool (or and$PREVINDEX (P x$NEXTINDEX1 x$NEXTINDEX2)))"
    fi





done

CURINDEX=`echo "scale=2; $CURINDEX - 1" | bc`	
echo "(assert and$CURINDEX)"

echo "(check-sat)"


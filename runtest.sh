#! /bin/bash

make

numCPUs=4
prog=functionLocalStaticCost

for mode in "global local";
do
  echo -n "$mode " >> scaling.txt
  for n in `seq $numCPUs`; 
  do
    for i in `seq 5`; 
      do 
      /usr/bin/time -f %e ./${prog} $n $mode 2> tmp_time

      t=`cat tmp_time`
      echo -n "$t " >> scaling.txt
    done
  done
  echo >> scaling.txt
done
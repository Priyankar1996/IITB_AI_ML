#!/bin/bash
for i in `seq 0 17`
do
	python f2s.py ${i}.csv >> kernels.txt
done

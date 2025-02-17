#!/usr/bin/bash

for((i=501;i<=600;i++))
do
	# mkdir $i
	if [ -d "$i/" ]; then
		
		cd $i
		# mv ../$i.xyz ./
		
		pwd	
		# cp ../md.inp md.inp
		# cp ../qsub.pbs qsub.pbs
		# qsub qsub.pbs
		# sleep 15
		# mv stru_xyz.in $i.xyz
		# xtb --md --input md.inp *.xyz > log

		
		pwd >> log
		dynReacExtr.py -i xtb.trj --refine --ts --xtbopt >> log
		
		cd ..
	fi
done


#!/bin/bash -e

#for i in {bootloader kernel};
#do
#	echo makeing in $(i);
#	cd $(i) ;
#	make all;
#	cd -;
#done

#!/bin/bash

for subdir in bootloader kernel ;
do
	echo makeing $subdir
	cd $subdir
	make all
	cd -
done

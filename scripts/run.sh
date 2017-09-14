#!/bin/sh
help(){
	cat<< HELP
this is the script to manipulate HPL.dat 
USAGE : ./run.sh [-aghd] [params]
	-d	: run in default settings; 
		  first getData() then analysis()
	-a	: call function analysis()
	-g num	: call function getData()
	-h	: call fuction help()
HELP
	exit 0
}
getData(){
	echo "Input the directory of Data folder :"
	read dataDir
	touch ./HPL.dat
	for file in ${dataDir}/*; do
		echo "COPY ${file} to ./HPL.dat"
		cp -f ${file} ./HPL.dat
		echo "starting xhpl"
		mpirun -np $1 ./xhpl
	done
}

analysis(){
	echo "starting analysiser..."
	for file in ./out/*; do
		echo "ANAL ${file}"
		./analysiser ${file}
	done
}

if [ $# -lt 1 ]; then
	help
fi

while [ -n "$1" ]; do 
case $1 in
	-h) help;shift 1;;
	-g) shift 1;getData $1;;
	-a) analysis;;
	-d) shift 1;getData $1;analysis;;
	-*) echo "Unknown command $1, use ./run.sh -h for help";exit 1;;
	*) break;;
esac
done

#getData
#analysis

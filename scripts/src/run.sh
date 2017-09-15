#!/bin/sh
generateData(){
	echo "files under ./script/Data will be removed!"
	rm -f ./script/Data/*
	if [ $# -lt 1 ]; then
		cd ./script && ./generate $1
	else
		cd ./script && ./generate 
	fi 
	
}
help(){
	cat<< HELP
this is the script to manipulate HPL.dat 

EXAMPLE : 
	./run.sh -G config.dat			# First, Generate data
	./run.sh -d 10				# Then copy files and run ./xhpl

USAGE	: ./run.sh [-agGhd] [params]
	-d <num>	: run in default settings; 
			  first getData() then analysis()

	-a		: call function analysis()

	-g <num>	: call function getData()
			  Copy files from './src/Data' to HPL.dat
			  and exec 'mpirun -np <num> ./xhpl'

	-h		: call fuction help()

	-G [filename]	: run generateData()
			  generate data to ./src/Data
			  default filename is 'config.dat'
HELP
	exit 0
}
getData(){
	mkdir -p out
	#echo "Input the directory of Data folder :"
	#read dataDir
	dataDir=./script/Data
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
	-G) shift 1;generateData $1;;
	-*) echo "Unknown command $1, use ./run.sh -h for help";exit 1;;
	*) break;;
esac
done

#getData
#analysis

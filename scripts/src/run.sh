#!/bin/bash
generateData(){
	echo "files under ./script/Data will be removed!"
	rm -f ./script/Data/*
	if [ $# -lt 1 ]; then
		cd ./script && ./generate $1
	else
		cd ./script && ./generate 
	fi 
	cd ..	
}
help(){
	cat<< HELP
this is the script to manipulate HPL.dat 

EXAMPLE : 
	./run.sh -G config.dat			# First, Generate data
	./run.sh -d 10				# Then copy files and run ./xhpl
  or 
	./run.sh -G -g 10 -a		# -G	: generate data
					# -g 10	: run xhpl with 10 processes
					# -a	: run analysiser	

USAGE	: ./run.sh [-G [filename]] -g <num> [-a] 
	OR
	  ./run.sh [-G [filename]] -d <num>

OPTIONS
	-a		: call function analysis()

	-d <num>	: run in default settings; 
			  first getData() then analysis()

	-g <num>	: call function getData()
			  Copy files from './src/Data' to HPL.dat
			  and exec 'mpirun -np <num> ./xhpl'

	-G [filename]	: run generateData()
			  generate data to ./src/Data
			  default filename is 'config.dat'

	-h		: call fuction help()
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
		if [ "${file##*.}"x = "out"x ]; then 
			echo "ANAL ${file}"
			./analysiser ${file}
		fi
	done
}

isNotNum(){
	rval=`awk 'BEGIN { if (match(ARGV[1],"[0-9]+$") != 0) print "false"; else print "true" }' $1`
	if [ "$rval" = "true" ]; then
		return 1;
	else
		return 0;	
	fi 
}

isdigit=`echo $1 | awk '{ if (match($1, "^[0-9]+$") != 0) print "true"; else print "false" }' `

if [ $# -lt 1 ]; then
	help
fi

while [ -n "$1" ]; do 
	case $1 in
		-h) help;shift 1;;
		-g) shift 1;				#SHIFT -g
			if [ "$1" -gt 0 ] 2>/dev/null ;then
				getData $1
				shift
			else
				echo "ERROR! The number of processes expected but '$1' received"
				break
			fi;;
		-a) analysis;shift 1;;		#-a : RUN analysis
		-d) shift 1;				#SHIFT -d
			if [ "$1" -gt 0 ] 2>/dev/null ;then
				getData $1
				shift
			else
				echo "ERROR! The number of processes expected but '$1' received"
				break
			fi;
			analysis;;				#RUN analysis
		-G) shift 1;								#SHIFT -G
			if [ "${1:0:1}"x = "-"x ]; then			#if next param is -*
				generateData						#use default generate
			else									#next param is filename
				generateData $1							#generate with filename
				shift 1;							#SHIFT filename
			fi;;
			
		-*) echo "Unknown command $1, use ./run.sh -h for help";exit 1;;
		*) break;;
	esac
done


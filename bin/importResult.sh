#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]]; do
	i=0
	s="{"
	for word in $line; do	
		if [ $i != 1 ] 
		then
			s=$(echo $s$word" ")
			i=1
		else
			s=$(echo $s$word",")
			i=0
		fi
    done
	s=$(echo ${s::-1}"}")	
	echo $s
done < mazowieckie.csv \
| mongoimport --drop -d test -c data

while IFS='' read -r line || [[ -n "$line" ]]; do
	i=0
	s="{"
	for word in $line; do	
		if [ $i != 1 ] 
		then
			s=$(echo $s$word" ")
			i=1
		else
			s=$(echo $s$word",")
			i=0
		fi
    done
	s=$(echo ${s::-1}"}")	
	echo $s
done < vehicles.csv \
| mongoimport -d test -c data

while IFS='' read -r line || [[ -n "$line" ]]; do
	i=0
	s="{"
	for word in $line; do	
		if [ $i != 1 ] 
		then
			s=$(echo $s$word" ")
			i=1
		else
			s=$(echo $s$word",")
			i=0
		fi
    done
	s=$(echo ${s::-1}"}")	
	echo $s
done < mazowieckie2.csv \
| mongoimport -d test -c data

while IFS='' read -r line || [[ -n "$line" ]]; do
	i=0
	s="{"
	for word in $line; do	
		if [ $i != 1 ] 
		then
			s=$(echo $s$word" ")
			i=1
		else
			s=$(echo $s$word",")
			i=0
		fi
    done
	s=$(echo ${s::-1}"}")	
	echo $s
done < vehicles2.csv \
| mongoimport -d test -c data



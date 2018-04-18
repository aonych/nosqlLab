#!/bin/bash
 
sudo rm -rf /srv/mongodb/carbon/data-1/*
sudo rm -rf /srv/mongodb/carbon/data-2/*
sudo rm -rf /srv/mongodb/carbon/data-3/*
 
sudo mongod --port 27001 --replSet carbon --dbpath ../carbon/data-1 --bind_ip localhost --oplogSize 128 \
  --wiredTigerJournalCompressor zlib --wiredTigerCollectionBlockCompressor zlib --fork --syslog
sudo mongod --port 27002 --replSet carbon --dbpath ../carbon/data-2 --bind_ip localhost --oplogSize 128 \
  --wiredTigerJournalCompressor zlib --wiredTigerCollectionBlockCompressor zlib --fork --syslog
sudo mongod --port 27003 --replSet carbon --dbpath ../carbon/data-3 --bind_ip localhost --oplogSize 128 \
  --wiredTigerJournalCompressor zlib --wiredTigerCollectionBlockCompressor zlib --fork --syslog
 
initiateComm="rs.initiate({ _id: 'carbon', version: 1, members: [ { _id: 0, host: 'localhost:27001' }, { _id: 1, host: 'localhost:27002' }, { _id: 2, host: 'localhost:27003' }]})"
echo $initiateComm > comm
 
mongo localhost:27001 comm
sleep 30s
 
> vehicles2.csv
> mazowieckie2.csv

for i in {0..4}
do 
	(time gunzip -c ../data/mazowieckie.json.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection wojewodztwo )2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom2=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom2 | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom2=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom2 | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom2=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom2 | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042default\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042default\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> mazowieckie2.csv
done	

for i in {0..4}
do 
	(time gunzip -c ../data/mazowieckie.json.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection wojewodztwo --writeConcern "{w:1,j:false}")2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom2=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom2 | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom2=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom2 | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom2=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom2 | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:1,j:false}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:1,j:false}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> mazowieckie2.csv
done	

for i in {0..4}
do 
	(time gunzip -c ../data/mazowieckie.json.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection wojewodztwo --writeConcern "{w:1,j:true}")2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom2=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom2 | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom2=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom2 | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom2=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom2 | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:1,j:true}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:1,j:true}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> mazowieckie2.csv
done	

for i in {0..4}
do 
	(time gunzip -c ../data/mazowieckie.json.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection wojewodztwo --writeConcern "{w:2,j:false}")2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom2=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom2 | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom2=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom2 | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom2=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom2 | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:2,j:false}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:2,j:false}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> mazowieckie2.csv
done	

for i in {0..4}
do 
	(time gunzip -c ../data/mazowieckie.json.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection wojewodztwo --writeConcern "{w:2,j:true}")2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom2=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom2 | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom2=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom2 | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom2=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom2 | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:2,j:true}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:2,j:true}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> mazowieckie2.csv
done	
for i in {0..4}
do 
	(time gunzip -c ../data/medallionVehicles.csv.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection vehicles --type csv --headerline )2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042default\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042default\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> vehicles2.csv	
done

for i in {0..4}
do 
	(time gunzip -c ../data/medallionVehicles.csv.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection vehicles --type csv --headerline --writeConcern "{w:1,j:false}")2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:1,j:false}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:1,j:false}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> vehicles2.csv	
done

for i in {0..4}
do 
	(time gunzip -c ../data/medallionVehicles.csv.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection vehicles --type csv --headerline --writeConcern "{w:1,j:true}")2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:1,j:true}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:1,j:true}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> vehicles2.csv	
done

for i in {0..4}
do 
	(time gunzip -c ../data/medallionVehicles.csv.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection vehicles --type csv --headerline --writeConcern "{w:2,j:false}")2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:2,j:false}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:2,j:false}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> vehicles2.csv	
done

for i in {0..4}
do 
	(time gunzip -c ../data/medallionVehicles.csv.gz | mongoimport --host localhost:27001,localhost:27002,localhost:27003 --drop --db test --collection vehicles --type csv --headerline --writeConcern "{w:2,j:true}")2>&1 | tee file.txt
	tail -5 file.txt > output.txt
	numberOfColumns=$(head -1 output.txt | awk 'END {print $(NF-1)}')
	
	real=$(tail -3 output.txt | head -1 | awk 'END {print $(NF-0)}')
	user=$(tail -2 output.txt | head -1 | awk 'END {print $(NF-0)}')
	sys=$(tail -1 output.txt | head -1 | awk 'END {print $(NF-0)}')

	minutesReal="$(cut -d'm' -f1 <<< ${real})"
	pom="$(cut -d'm' -f2 <<< ${real})"	
	secondsReal="$(cut -d's' -f1 <<< $pom)"
	pom=$(echo $(($minutesReal*60)) $secondsReal | awk '{print $1 + $2}')
	timeReal=0
	timeReal=$(echo $timeReal $pom | awk '{print $1 + $2}')
	
	minutesUser="$(cut -d'm' -f1 <<< ${user})"
	pomUser="$(cut -d'm' -f2 <<< ${user})"	
	secondsUser="$(cut -d's' -f1 <<< $pomUser)"
	pom=$(echo $(($minutesUser*60)) $secondsUser | awk '{print $1 + $2}')
	timeUser=0
	timeUser=$(echo $timeUser $pom | awk '{print $1 + $2}')
	
	minutesSys="$(cut -d'm' -f1 <<< ${sys})"
	pomSys="$(cut -d'm' -f2 <<< ${sys})"	
	secondsSys="$(cut -d's' -f1 <<< $pomSys)"
	pom=$(echo $(($minutesSys*60)) $secondsSys | awk '{print $1 + $2}')
	timeSys=0
	timeSys=$(echo $timeSys $pom | awk '{print $1 + $2}')
	
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:2,j:true}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys''
	echo -e 'colNumber: '$numberOfColumns' type: \042replica_set\042 write_concern: \042{w:2,j:true}\042 real: '$timeReal' user: '$timeUser' sys: '$timeSys'' >> vehicles2.csv	
done

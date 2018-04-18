#!/bin/bash

cd ..
mvn exec:java -Dexec.mainClass=vehicles.CountDaysToExpirationDate -Dexec.args=$1 -Dexec.cleanupDaemonThreads=false
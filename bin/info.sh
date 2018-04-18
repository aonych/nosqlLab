#!/bin/bash

cd ..
mvn exec:java -Dexec.mainClass=vehicles.CollectionInfoToFile -Dexec.cleanupDaemonThreads=false
#!/bin/bash

cd ..
mvn exec:java -Dexec.mainClass=vehicles.CreateIndexes -Dexec.cleanupDaemonThreads=false
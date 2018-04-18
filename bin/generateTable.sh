#!/bin/bash

printf "Columns |    Type    |         Write Concern      |  Time averages\n"
mongo --eval 'db.data.aggregate([
{$group: {_id: {write_concern: "$write_concern", colNumber: "$colNumber", type: "$type"}, avgReal: {$avg: "$real"}, avgUser: {$avg: "$user"}, avgSys: {$avg: "$sys"}}}
]).forEach(function(r) {print(r._id.colNumber, "|", r._id.type, "|", r._id.write_concern, "|", "real:", r.avgReal+"s", "user:", r.avgUser+"s", "sys:", r.avgSys+"s")})' | tail -n +4
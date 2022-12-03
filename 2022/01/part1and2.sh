#/bin/bash
awk '{s+=$1} /^$/ {print s ; s=0} END {print s}' input | sort -n | tail -n 3 | awk '{s+=$1} END {print $0"\n"s}'

#/bin/bash
cat input | awk '/[0-9]+/ {s+=$1} /^$/ {print s ; s=0} END {print s}' | sort -n | tail -n 3 | awk '{s+=$1} END {print s}'

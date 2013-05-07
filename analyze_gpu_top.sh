#!/bin/bash
file=$1
cat $file|awk '{
					if (NR > 1){
						render_sum+=$2
						bitstr_sum+=$6
					}
				}
				END{
					printf "Render %3.2f%%\tBitstr %3.2f%%\n", render_sum/(NR-1), bitstr_sum/(NR-1)
				}'

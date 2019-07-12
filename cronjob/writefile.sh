#!/bin/bash -l
cd /home/rmudafor/Development/cdash/cronjob
timestamp=`date +%b%d_%I%M%P`
touch yoyo.$timestamp.$1.tmp

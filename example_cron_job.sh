#!/bin/sh
cd /usr/src/app
#this requires the full path to python as cron doesn't inherit any path information
/usr/local/bin/python cron_job.py
#!/bin/bash
ps -eLo psr,user,pid,ppid,lwp,args|grep -P -e ^\\s+$1\\s\\w+\\s+\\d+\\s+\\d+\\s+\\d+\\s+\\[.+\\]$


#!/bin/bash
echo $@ >/dev/shm/longrun$$
sleep 10


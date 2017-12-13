#!/usr/bin/python
#please sudo su before running
from optparse import OptionParser
import os
import signal
import sys, subprocess
import thread
from threading import Thread
import re


def parse():
    parser = OptionParser()
    #parser.add_option("-p", "--path", action="store", help="directory to dump the logs\n")
    parser.add_option("-n", "--name", action="store", help="name of the workload for the report file")
    (options, args) = parser.parse_args()

    if not options.name:
        parser.print_help()
        parser.error("Wrong number of arguments")

    return options
# single setting
masks=['0x00003', '0x00007','0x0000F',\
       '0x0001F', '0x0003F', '0x0007F', '0x000FF',\
       '0x001FF', '0x003FF', '0x007FF', '0x00FFF',\
       '0x01FFF', '0x03FFF', '0x07FFF', '0x0FFFF',\
       '0x1FFFF', '0x3FFFF', '0x7FFFF', '0xFFFFF']

options=parse()

configurations=[2, 4, 6, 8, 10, 12, 14, 16, 18]

latency_array=[0]*len(configurations)
LLCMisses_array=[0]*len(configurations)
IPC_array=[0]*len(configurations)

cmd= "cat ./{}".format(options.name)

(out, err) = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
out=out.split("\n")[:-1]

for id in range(len(out)):
    if (id) % 3 == 1:
        IPC_array[id/3]=float(out[id].split(" ")[3].split(",")[0])
        LLCMisses_array[id/3]=float(out[id].split(" ")[4].split(",")[0])
        latency_array[id/3]=float(out[id].split(" ")[5].split(",")[0])
print IPC_array
print LLCMisses_array
print latency_array

search_idx=6
ref_idx=len(configurations)-1
jumpSize=4

seen=[0]*len(configurations)
seen[ref_idx]=1

while (True):
    # print configurations[search_idx]
    print search_idx
    if search_idx > 8:
        search_idx = 8
    if search_idx < 0:
        search_idx = 0
    # print jumpSize
    if seen[search_idx] == 1:
        print "break1"
        break;
    elif latency_array[search_idx] > (1.1 * latency_array[ref_idx]):
        #start gradient descent
        seen[search_idx]=1
        search_idx += jumpSize
        jumpSize /= 2
        if jumpSize == 0:
            print "break2"
            break
    elif latency_array[search_idx] < (1.05 * latency_array[ref_idx]):
        #search gradient descent
        seen[search_idx]=1
        search_idx -= jumpSize
        jumpSize /= 2
        if jumpSize == 0:
            print "break3"
            break
    elif latency_array[search_idx] > (1.05 * latency_array[ref_idx]) and  latency_array[search_idx] < (1.1 * latency_array[ref_idx]):
        seen[search_idx]=1
        search_idx -= jumpSize
        jumpSize /= 2
        if jumpSize == 0:
            print "break4"
            break

print "Working set size is: {}".format(configurations[search_idx])

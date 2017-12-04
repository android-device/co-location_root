#!/usr/bin/python
#please sudo su before running
from optparse import OptionParser
import os
import signal
import sys, subprocess
import thread
from threading import Thread
import re

upper_bound = 0.8
lower_bound = 0.7

def signal_handler(signal, frame):
    print('You pressed Ctrl+C!')
    sys.exit(0)
    quit()

def parse():
    parser = OptionParser()
    #parser.add_option("-p", "--path", action="store", help="directory to dump the logs\n")
    parser.add_option("-c", "--command", action="store", help="command")
    parser.add_option("-d", "--command2", action="store", help="command to run alongside the first")
    parser.add_option("-s", "--socket", action="store", help="socket_id")
    parser.add_option("-n", "--name", action="store", help="name of the workload for the report file")
    (options, args) = parser.parse_args()

    if not options.command:
        parser.print_help()
        parser.error("Wrong number of arguments")

    return options

# co-location setting
#masks=['0x00003', '0x00007','0x0000F',\
#       '0x0001F', '0x0003F', '0x0007F', '0x000FF',\
#       '0x001FF', '0x003FF', '0x007FF', '0x00FFF',\
#       '0x01FFF', '0x03FFF', '0x07FFF', '0x0FFFF',\
#       '0x1FFFF', '0x3FFFF']
#
#c_masks=['0xFFFFC', '0xFFFF8','0xFFFF0',\
#       '0xFFFE0', '0xFFFC0', '0xFFF80', '0xFFF00',\
#       '0xFFE00', '0xFFC00', '0xFF800', '0xFF000',\
#       '0xFE000', '0xFC000', '0xF8000', '0xF0000',\
#       '0xE0000', '0xC0000']

# single setting
masks=['0x00003', '0x00007','0x0000F',\
       '0x0001F', '0x0003F', '0x0007F', '0x000FF',\
       '0x001FF', '0x003FF', '0x007FF', '0x00FFF',\
       '0x01FFF', '0x03FFF', '0x07FFF', '0x0FFFF',\
       '0x1FFFF', '0x3FFFF', '0x7FFFF', '0xFFFFF']

options=parse()
#if int(options.socket) == 0:
#	offset=0
#elif int(options.socket) == 1:
#	offset=16

def run_workload(cmd):
    print cmd
    os.system(cmd)

# calculate the reference LLCMiss and IPC
num_partitions=18
num_cores=7
Ref_IPC=0
Ref_LLCMisses=0
Ref_Latency=0
partition_list_str = "llc:0={}".format(masks[num_partitions])
allocation_list_str ="llc:0={}-{}".format(0, num_cores)

allocation_list_str ="llc:0={}-{}, llc:1={}-{}".format(0, num_cores, num_cores+1, 7)
#print "{}-{}".format(num_partitions, num_cores)
cmd= "sudo pqos -e {} -a {}".format(partition_list_str, allocation_list_str)
print cmd
os.system(cmd)
  
for i in range(5):
    # thrash llc
    cmd = "./thrash_cache.o"
    os.system(cmd)
    log_name="log-{}-{}-{}.txt".format(num_partitions, num_cores, i)
    cmd= "perf stat -e cycles,cpu-clock,cache-references,instructions,LLC-loads,LLC-load-misses,LLC-stores,LLC-prefetches -o {} taskset -c {}-{} {}".format(log_name, 0, num_cores, options.command, log_name)
    print cmd
    os.system(cmd)
    cmd= "cat ./{}".format(log_name)
    (out, err) = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    out=out.split("\n")[:-1]
    m=re.search('\d*\.\d*', out[8])
    #print m.group(0)
    Ref_IPC+=float(m.group(0))
    m=re.search('\d*\.\d*', out[10])
    #print m.group(0)
    Ref_LLCMisses+=float(m.group(0))
    Ref_Latency+=float(out[14].lstrip(' ').split(' ')[0])

# take average of Ref_IPC and Ref_LLCMisses
Ref_IPC/=5
Ref_LLCMisses/=5
Ref_Latency/=5

print "Reference IPC is: {}".format(Ref_IPC)
print "Refernce LLC Misses is: {}".format(Ref_LLCMisses)
print "Refernce Latency is: {}".format(Ref_Latency)

#for num_partitions in range(18) : #change number of ways from 1 to 20
num_partitions=2
num_cores=8
iteration=0
IPC=0
LLCMisses=0
iteration=0

jumpSize=4
#while (True):

try:
	the_file = open("/home/josers2/report_{}.txt".format(options.name), 'w')
except:
	print("File cannot be opened")

for num_partitions in [2, 4, 6, 8, 10, 12, 14, 16, 18]:
    latency=0
    LLCMisses=0
    IPC=0
    partition_list_str = "llc:0={}".format(masks[num_partitions])
    allocation_list_str ="llc:0={}-{}".format(0, num_cores)
    #print "{}-{}".format(num_partitions, num_cores)
    cmd= "sudo pqos -e {} -a {}".format(partition_list_str, allocation_list_str)
    print cmd
    os.system(cmd)
   
    for i in range(5):
        # thrash llc
        cmd = "./thrash_cache.o"
        os.system(cmd)
        
        log_name="log-{}-{}-{}.txt".format(num_partitions, num_cores, i)
        cmd= "perf stat -e cycles,cpu-clock,cache-references,instructions,LLC-loads,LLC-load-misses,LLC-stores,LLC-prefetches -o {} taskset -c {}-{} {}".format(log_name, 0, num_cores, options.command, log_name)
        os.system(cmd)
        cmd= "cat ./{}".format(log_name)
        (out, err) = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        out=out.split("\n")[:-1]
        m=re.search('\d*\.\d*', out[8])
        #print m.group(0)
        IPC+=float(m.group(0))
        m=re.search('\d*\.\d*', out[10])
        #print m.group(0)
        LLCMisses+=float(m.group(0))
        latency+=float(out[14].lstrip(' ').split(' ')[0])
    IPC/=5
    LLCMisses/=5
    latency/=5
    print "num_partition is: {} , latency is: {}".format(num_partitions, latency)
    the_file.write("num_partition: {}\n".format(num_partitions))
    the_file.write("IPC, MissRate, Latency: {}, {}, {}\n\n".format(IPC, LLCMisses, latency))

the_file.close()
#    if (LLCMisses > lower_bound * Ref_LLCMisses and LLCMisses < upper_bound * Ref_LLCMisses):
#        #or (IPC > lower_bound * Ref_IPC and IPC < upper_bound * Ref_IPC):
#        break;
#    elif LLCMisses > upper_bound * Ref_LLCMisses:
#        num_partitions += (18 - num_partitions)/ 2
#    elif LLCMisses < lower_bound * Ref_LLCMisses:
#        num_partitions -= 1
#
    #if latency > 1.05 * Ref_Latency and  latency < 1.075 * Ref_Latency:
    #    # start gradient descent
    #    num_partitions-=jumpSize
    #    jumpSize/=2
    #    if jumpSize == 0:
    #        break
    #elif latency > 1.075 * Ref_Latency:
    #    num_partitions += jumpSize
    #    jumpSize/=2
    #    if jumpSize == 0:
    #        break;
    #else:
    #    print "here!"
    #    #break

#print "Working set size is: {}".format(num_partitions)

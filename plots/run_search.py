#!/usr/bin/python
#please sudo su before running
from optparse import OptionParser
import os
import signal
import sys, subprocess
import thread
from threading import Thread
import re


# GLOBAL VARIABLES
LOGS = "./logs"
RESULTS = "./searchs"

# Read files
for _, _, files in os.walk(LOGS):
    # Parse file
    for fname in files:
        print fname
        name = fname[7:-4]
        f = open(LOGS+"/"+fname)
        data = re.findall(r"[-+]?\d*\.\d+|\d+", f.read())
        f.close()
        num = data[0::4]
        ipc = data[1::4]
        miss = data[2::4]
        time = [float(x) for x in data[3::4]]
    
        # Search
        search_idx = 6
        ref_idx = len(num) - 1
        jumpSize = 4
        seen=[0]*len(num)
        seen[ref_idx]=1
        
        fres = open(RESULTS+"/"+fname, "w+")
        while True:
            if search_idx > 8:
                search_idx = 8
            if search_idx < 0:
                search_idx = 0
            fres.write(str(search_idx)+"\n")
            # print jumpSize
            if seen[search_idx] == 1:
                #print "break1"
                break
            elif time[search_idx] > (1.1 * time[ref_idx]):
                #start gradient descent
                seen[search_idx]=1
                search_idx += jumpSize
                jumpSize /= 2
                if jumpSize == 0:
                    #print "break2"
                    break
            elif time[search_idx] < (1.05 * time[ref_idx]):
                #search gradient descent
                seen[search_idx]=1
                search_idx -= jumpSize
                jumpSize /= 2
                if jumpSize == 0:
                    #print "break3"
                    break
            elif time[search_idx] > (1.05 * time[ref_idx]) and  time[search_idx] < (1.1 * time[ref_idx]):
                seen[search_idx]=1
                search_idx -= jumpSize
                jumpSize /= 2
                if jumpSize == 0:
                    #print "break4"
                    break
        fres.write(num[search_idx])
        fres.close()
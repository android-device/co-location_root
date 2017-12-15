
import os
import sys
import re
import matplotlib.pyplot as plt; plt.rcdefaults()
import numpy as np
import matplotlib.pyplot as plt


# GLOBAL VARIABLES
LOGS = "./logs"
SEARCHS = "./searchs"
RESULTS = "./results"
 
# Read files
for _, _, files in os.walk(LOGS):
    for fname in files:
        print fname
        # Parse log file
        name = fname[7:-4]
        name = name.replace('_done', '')
        print name
        print len(name)
        if len(name) <= 3:
            name = name.upper()
        else:
            name = name.title()
        f = open(LOGS+"/"+fname)
        data = re.findall(r"[-+]?\d*\.\d+|\d+", f.read())
        f.close()
        num = [int(x)+2 for x in data[0::4]]
        ipc = data[1::4]
        miss = data[2::4]
        time = data[3::4]

        # Parse search file
        f = open(SEARCHS+"/"+fname)
        data = re.findall(r"[-+]?\d*\.\d+|\d+", f.read())
        f.close()
        path = data[:-1]
        optimal = int(data[-1]) + 2

        # Time
        time = [float(x) for x in time]
        plt.title(name, fontweight="bold")
        plt.ylim([min(time) - 2, max(time) + 2])
        plt.plot(num,time)
        plt.axvline(x=optimal, color='r', linestyle='-')
        plt.xlabel('Partition Size (MB)')
        plt.ylabel('Time (Seconds)')
        plt.savefig(RESULTS+"/"+name+"_time.pdf", bbox_inches='tight')
        plt.savefig(RESULTS+"/"+name+"_time.png")
        plt.clf()

        # SpeedUP
        objects = ('BubbleSort', 'OPS')
        y_pos = np.arange(len(objects))
        performance = [0]*2
        for t in time:
            performance[0]+= 5*float(t)
        for step in path:
            performance[1]+= 5*float(time[int(step)])

        plt.title(name, fontweight="bold")
        plt.bar(y_pos, performance, align='center')
        plt.xticks(y_pos, objects)
        plt.ylabel('Algorithms')
        plt.ylabel('Time (seconds)')
        plt.savefig(RESULTS+"/"+name+"_spedup.pdf", bbox_inches='tight')
        plt.savefig(RESULTS+"/"+name+"_spedup.png")
        plt.clf()

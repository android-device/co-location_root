#! /bin/bash

workloads=()
#machine learning (mlpack)
workloads += ('knn')
workloads += ('nmf')
#database
workloads += ('redis')
workloads += ('sysbench')
#map-reduce
workloads += ('grep')
workloads += ('wordcount')
#graph-analytics
workloads += ('galois-sssp')
workloads += ('galois-pagerank')
#tail-bench
workloads += ('moses')
workloads += ('sphinx')
workloads += ('img-dnn')



for workload in ${workloads[@]}
do
	touch ~/report_$workload.txt
	if [ $workload == "knn" ]
	then
		python run_configurations.py -name $workload -c "/home/heidars2/mlpack/build/bin/mlpack_knn -r ../../../mlpack-benchmarks/datasets/mnist_all.csv -k 10 -v"

	elif [ $workload == "nmf" ]
	then
		python run_configurations.py -name $workload -c "/home/heidars2/mlpack/build/bin/mlpack_nmf -r 10 -i ~/mlpack-benchmarks/datasets/TomsHardware.csv
"
	elif [ $workload == "redis" ]
	then
		/home/alberto6/redis-4.0.5/src/redis-server
		python run_configurations.py -name $workload -c "/home/alberto6/redis-4.0.5/src/redis-benchmark -q -n 500000 -r 1000"

	elif [ $workload == "grep" ]
	then
		python run_configurations.py -name $workload -c "/home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/MicroBenchmarks/run_MicroBenchmarks.sh 2"
	elif [ $worklaod == "wordcount" ]
	then
		python run_configurations.py -name $workload -c "/home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/MicroBenchmarks/run_MicroBenchmarks.sh 3"
	elif [ $workload == "galois-sssp" ]
	then
	elif [ $workload == "galois-pagerank" ]
	then

	elif [ $worloads == "moses" ]
	then
		python run_configurations.py -name $workload -c "/home/alberto6/Tailbench/tailbench-v0.9/img-dnn//home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/MicroBenchmarks/run_MicroBenchmarks.sh 3"
	fi
done


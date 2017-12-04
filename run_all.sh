#! /bin/bash

workloads=()
#machine learning (mlpack)
workloads+=('knn')
workloads+=('nmf')
#database
workloads+=('redis')
workloads+=('sysbench')
#map-reduce
workloads+=('grep')
workloads+=('wordcount')
#graph-analytics
workloads+=('galois-sssp')
workloads+=('galois-pagerank')
#tail-bench
workloads+=('moses')
workloads+=('xapian')
workloads+=('img-dnn')
workloads+=('sphinx')
workloads+=('slio')



for workload in ${workloads[@]}
do
	touch ~/report_$workload.txt
	if [ $workload == "knn" ]
	then
		python run_configurations.py -name $workload -c "/home/heidars2/mlpack/build/bin/mlpack_knn -r /home/heidars2/mlpack-benchmarks/datasets/mnist_all.csv -k 10 -v"

	elif [ $workload == "nmf" ]
	then
		python run_configurations.py -name $workload -c "/home/heidars2/mlpack/build/bin/mlpack_nmf -r 10 -i /home/heidars2/mlpack-benchmarks/datasets/TomsHardware.csv
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
		echo hi
	elif [ $workload == "galois-pagerank" ]
	then
		echo hi
	elif [ $worloads == "img-dnn" ]
	then
		python run_configurations.py -name $workload -c "/home/alberto6/Tailbench/tailbench-v0.9/img-dnn/run.sh"
	elif [ $worloads == "moses" ]
	then
		python run_configurations.py -name $workload -c "/home/alberto6/Tailbench/tailbench-v0.9/moses/run.sh"
	
	elif [ $worloads == "sphinx" ]
	then
		python run_configurations.py -name $workload -c "/home/alberto6/Tailbench/tailbench-v0.9/sphinx/run.sh"

	elif [ $worloads == "xapian" ]
	then
		python run_configurations.py -name $workload -c "/home/alberto6/Tailbench/tailbench-v0.9/xapian/run.sh"

	elif [ $worloads == "silo" ]
	then
		python run_configurations.py -name $workload -c "/home/alberto6/Tailbench/tailbench-v0.9/silo/run.sh"
fi
done


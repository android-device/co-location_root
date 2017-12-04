#! /bin/bash

workloads=()
#machine learning (mlpack)
workloads+=('knn')
workloads+=('nmf')
#database
workloads+=('redis')
#workloads+=('sysbench')
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
# stream
workloads+=('xstream')



for workload in ${workloads[@]}
do
	touch /home/josers2/report_$workload.txt
	if [ $workload == "knn" ]
	then
		python run_configurations.py --name knn -c "/home/heidars2/mlpack/build/bin/mlpack_knn -r /home/heidars2/mlpack-benchmarks/datasets/TomsHardware.csv -k 10 -v"

	elif [ $workload == "nmf" ]
	then
		python run_configurations.py --name nmf -c "/home/heidars2/mlpack/build/bin/mlpack_nmf -r 10 -i /home/heidars2/mlpack-benchmarks/datasets/TomsHardware.csv
		"
	elif [ $workload == "redis" ]
	then
		/home/alberto6/redis-4.0.5/src/redis-server
		python run_configurations.py --name redis -c "/home/alberto6/redis-4.0.5/src/redis-benchmark -q -n 500000 -r 1000"

	elif [ $workload == "grep" ]
	then
		python run_configurations.py --name grep -c "/home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/MicroBenchmarks/run_MicroBenchmarks.sh 2"
	elif [ $worklaod == "wordcount" ]
	then
		python run_configurations.py --name wordcount -c "/home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/MicroBenchmarks/run_MicroBenchmarks.sh 3"
	elif [ $workload == "galois-sssp" ]
	then
		echo hi
	elif [ $workload == "galois-pagerank" ]
	then
		echo hi
	elif [ $workload == "img-dnn" ]
	then
		python run_configurations.py --name img-dnn -c "/home/alberto6/Tailbench/tailbench-v0.9/img-dnn/run.sh"
	elif [ $workload == "moses" ]
	then
		python run_configurations.py --name moses -c "/home/alberto6/Tailbench/tailbench-v0.9/moses/run.sh"

	elif [ $workload == "sphinx" ]
	then
		python run_configurations.py --name sphinx -c "/home/alberto6/Tailbench/tailbench-v0.9/sphinx/run.sh"

	elif [ $workload == "xapian" ]
	then
		python run_configurations.py --name xapian -c "/home/alberto6/Tailbench/tailbench-v0.9/xapian/run.sh"

	elif [ $workload == "silo" ]
	then
		python run_configurations.py --name silo -c "/home/alberto6/Tailbench/tailbench-v0.9/silo/run.sh"
	elif [ $workload == "xstream" ]
		python run_configurations.py --name xstream -c "benchmark_driver -g test -b pagerank --pagerank::niters 10 -a -p 16 --physical_memory 268435456"
	fi
done


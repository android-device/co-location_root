#! /bin/bash

workloads=()
#machine learning (mlpack)
#workloads+=('knn')
#workloads+=('nmf')
#database
#workloads+=('redis')
#workloads+=('sysbench')
#map-reduce

# workloads+=('grep')
# workloads+=('wordcount')

#graph-analytics
#workloads+=('galois-sssp')
#workloads+=('galois-pagerank')
#tail-bench
# workloads+=('moses')

# workloads+=('xapian')

# workloads+=('img-dnn')
# workloads+=('sphinx')
# workloads+=('slio')
# stream
#workloads+=('xstream')

# workloads+=('mlpack_allkfn')
# workloads+=('mlpack_allknn')
# workloads+=('mlpack_kfn')
# workloads+=('mlpack_knn')
# workloads+=('mlpack_lsh')

# workloads+=('mlpack_adaboost')
# workloads+=('mlpack_cf')
# workloads+=('mlpack_decision_stump')
# workloads+=('mlpack_decision_tree')
# workloads+=('mlpack_det')
# workloads+=('mlpack_linear_regression')
# workloads+=('mlpack_nbc')
# workloads+=('mlpack_perceptron')

workloads+=('wordcount')
#workloads+=('galois')
#workloads+=('silo')
workloads+=('masstree')

for workload in ${workloads[@]}
do
	touch /home/josers2/report_$workload.txt
	if [ $workload == "knn" ]
	then
		python /home/josers2/run_configurations.py --name knn -c "/home/heidars2/mlpack/build/bin/mlpack_knn -r /home/heidars2/mlpack-benchmarks/datasets/TomsHardware.csv -k 10 -v"

	elif [ $workload == "nmf" ]
	then
		python /home/josers2/run_configurations.py --name nmf -c "/home/heidars2/mlpack/build/bin/mlpack_nmf -r 10 -i /home/heidars2/mlpack-benchmarks/datasets/TomsHardware.csv
		"
	elif [ $workload == "redis" ]
	then
		/home/alberto6/redis-4.0.5/src/redis-server
		python /home/josers2/run_configurations.py --name redis -c "/home/alberto6/redis-4.0.5/src/redis-benchmark -q -n 500000 -r 1000"

	elif [ $workload == "grep" ]
	then
		source /home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/conf.properties
		pushd /home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/MicroBenchmarks
		python /home/josers2/run_configurations.py --name grep -c "/home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/MicroBenchmarks/run_MicroBenchmarks.sh 2"
		popd
	elif [ $workload == "wordcount" ]
	then
		source /home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/conf.properties
		pushd /home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/MicroBenchmarks
		python /home/josers2/run_configurations.py --name wordcount -c "/home/josers2/BigDataBench_V3.2.1_Hadoop_Hive/MicroBenchmarks/run_MicroBenchmarks.sh 3"
		popd
	elif [ $workload == "galois" ]
	then
		python /home/josers2/run_configurations.py --name galois -c "/home/heidars2/Galois-2.2.1/build/apps/sssp/sssp -t 8 -wl obim -noverify -startNode 0 -delta 2 /home/heidars2/Galois-2.2.1/build/apps/soc-LiveJournal1.bin"
	elif [ $workload == "img-dnn" ]
	then
		cd /home/alberto6/tailbench/tailbench-v0.9/img-dnn
		python /home/josers2/run_configurations.py --name img-dnn -c "./run.sh"
		cd /home/josers2
	elif [ $workload == "moses" ]
	then
		cd /home/alberto6/tailbench/tailbench-v0.9/moses
		python /home/josers2/run_configurations.py --name moses -c "/home/alberto6/tailbench/tailbench-v0.9/moses/run.sh"
		cd /home/josers2
	elif [ $workload == "sphinx" ]
	then
		cd /home/alberto6/tailbench/tailbench-v0.9/sphinx
		python /home/josers2/run_configurations.py --name sphinx -c "/home/alberto6/tailbench/tailbench-v0.9/sphinx/run.sh"
		cd /home/josers2
	elif [ $workload == "xapian" ]
	then
		cd /home/alberto6/tailbench/tailbench-v0.9/xapian
		python /home/josers2/run_configurations.py --name xapian -c "/home/alberto6/tailbench/tailbench-v0.9/xapian/run.sh"
		cd /home/josers2
	elif [ $workload == "silo" ]
	then
		cd /home/alberto6/tailbench/tailbench-v0.9/silo
		python /home/josers2/run_configurations.py --name silo -c "/home/alberto6/tailbench/tailbench-v0.9/silo/run.sh"
		cd /home/josers2

	elif [ $workload == "masstree" ]
	then
		cd /home/alberto6/tailbench/tailbench-v0.9/masstree
		python /home/josers2/run_configurations.py --name masstree -c "/home/alberto6/tailbench/tailbench-v0.9/masstree/run.sh"
		cd /home/josers2

	elif [ $workload == "xstream" ]
	then
		rmat --name test --scale 20 --edges 16777216
		export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
		python /home/josers2/run_configurations.py --name xstream -c "benchmark_driver -g test -b pagerank --pagerank::niters 10 -a -p 16 --physical_memory 268435456"

	elif [ $workload == "mlpack_allkfn" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_allkfn -c "/home/heidars2/mlpack/build/bin/mlpack_allkfn -r testSet.csv -n ./output/neighbors_out.csv -d ./output/distances_out.csv -k 5 -v"
		popd
	elif [ $workload == "mlpack_allknn" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_allknn -c "/home/heidars2/mlpack/build/bin/mlpack_allknn -r testSet.csv -n ./output/neighbors_out.csv -d ./output/distances_out.csv -k 5 -v"
		popd
	elif [ $workload == "mlpack_kfn" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_kfn -c "/home/heidars2/mlpack/build/bin/mlpack_kfn -r testSet.csv -n ./output/neighbors_out.csv -d ./output/distances_out.csv -k 5 -v"
		popd
	elif [ $workload == "mlpack_knn" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_knn -c "/home/heidars2/mlpack/build/bin/mlpack_knn -r testSet.csv -n ./output/neighbors_out.csv -d ./output/distances_out.csv -k 5 -v"
		popd
	elif [ $workload == "mlpack_lsh" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_lsh -c "/home/heidars2/mlpack/build/bin/mlpack_lsh -r testSet.csv -n ./output/neighbors_out.csv -d ./output/distances_out.csv -k 5 -v"
		popd

	elif [ $workload == "mlpack_adaboost" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_adaboost -c "/home/heidars2/mlpack/build/bin/mlpack_adaboost --training_file trainSet.csv  -v"
		popd
	elif [ $workload == "mlpack_cf" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_cf -c "/home/heidars2/mlpack/build/bin/mlpack_cf --training_file trainSet.csv  -v"
		popd
	elif [ $workload == "mlpack_decision_stump" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_decision_stump -c "/home/heidars2/mlpack/build/bin/mlpack_decision_stump --training_file trainSet.csv  -v"
		popd
	elif [ $workload == "mlpack_decision_tree" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_decision_tree -c "/home/heidars2/mlpack/build/bin/mlpack_decision_tree --training_file trainSet.csv  -v"
		popd
	elif [ $workload == "mlpack_det" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_det -c "/home/heidars2/mlpack/build/bin/mlpack_det --training_file trainSet.csv  -v"
		popd
	elif [ $workload == "mlpack_linear_regression" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_linear_regression -c "/home/heidars2/mlpack/build/bin/mlpack_linear_regression --training_file trainSet.csv  -v"
		popd
	elif [ $workload == "mlpack_nbc" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_nbc -c "/home/heidars2/mlpack/build/bin/mlpack_nbc --training_file trainSet.csv  -v"
		popd
	elif [ $workload == "mlpack_perceptron" ]
	then
		pushd /home/heidars2/mlpack/build
		python /home/josers2/run_configurations.py --name mlpack_perceptron -c "/home/heidars2/mlpack/build/bin/mlpack_perceptron --training_file trainSet.csv  -v"
		popd

	fi
done

#! /usr/bin/env bash

REPITITIONS=100

cd ..


rebuild(){
rm -r build_bench
mkdir build_bench
build_it
}

build_it(){

cd build_bench
mkdir benchmark
cmake .. -doption_build_benchmarks=true -doption_build_tools=false -dcmake_build_type=release
make -j4
cd ..
}

bench_omp(){
build_omp
run
cp build_bench/benchmark/results.csv benchmarking/omp_result.csv
}

bench_no_omp(){
build_no_omp
run
cp build_bench/benchmark/results.csv benchmarking/no_omp_result.csv
}

build_omp()
{
rm -r build_bench
mkdir build_bench
cd build_bench
mkdir benchmark
cmake .. -DOPTION_BUILD_BENCHMARKS=true -DOPTION_BUILD_TOOLS=false -DCMAKE_BUILD_TYPE=release
make -j4
cd ..
}

build_no_omp()
{
rm -r build_bench
mkdir build_bench
cd build_bench
mkdir benchmark
cmake .. -DOPTION_BUILD_BENCHMARKS=true -DOPTION_BUILD_TOOLS=false -DCMAKE_BUILD_TYPE=release -DUSE_OPENMP=FALSE
make -j4
cd ..
}

run(){
build/glkernel-benchmark --benchmark_out=build/benchmark/results.csv \
                     --benchmark_out_format=csv \
                     --benchmark_repetitions=$REPITITIONS
}

build_it
rebuild
bench_omp
bench_no_omp

# make_graphs

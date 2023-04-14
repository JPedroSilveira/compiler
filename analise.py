import subprocess
import time
import statistics

num_iterations = 500

def get_execution_times(program_name):
    execution_times = []

    for i in range(num_iterations):
        start_time = time.perf_counter()
        subprocess.run([program_name])
        end_time = time.perf_counter()
        execution_times.append(end_time - start_time)

    return execution_times

default_execution_times = get_execution_times("./program_default")

default_mean_time = statistics.mean(default_execution_times)
default_std_dev = statistics.stdev(default_execution_times)

print("Default mean: {:.5f} seconds".format(default_mean_time))
print("Default standard deviation: {:.5f} seconds".format(default_std_dev))

optimized_execution_times = get_execution_times("./program_optimized")

optimized_mean_time = statistics.mean(optimized_execution_times)
optimized_std_dev = statistics.stdev(optimized_execution_times)

print("Optimized mean: {:.5f} seconds".format(optimized_mean_time))
print("Optimized standard deviation: {:.5f} seconds".format(optimized_std_dev))
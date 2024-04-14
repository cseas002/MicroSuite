import sys

def parse_file(file_path):
    averages = []
    percentiles_99 = []

    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('Average Response Time(ms):'):
                average = float(line.split(':')[1].strip())
                averages.append(average)
            elif '99th:' in line:
                percentile_99 = float(line.split('99th:')[1].split()[0])
                percentiles_99.append(percentile_99)

    return averages, percentiles_99

def calculate_metrics(averages, percentiles_99):
    average_of_averages = sum(averages) / len(averages)
    average_of_percentiles_99 = sum(percentiles_99) / len(percentiles_99)
    highest_99th_percentile = max(percentiles_99)
    
    return average_of_averages, average_of_percentiles_99, highest_99th_percentile

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <file_path>")
        return

    file_path = sys.argv[1]
    averages, percentiles_99 = parse_file(file_path)
    if averages and percentiles_99:
        average_of_averages, average_of_percentiles_99, highest_99th_percentile = calculate_metrics(averages, percentiles_99)
        print(f"Average of averages: {average_of_averages}")
        print(f"Average of the 99th percentile tail latencies: {average_of_percentiles_99}")
        print(f"Highest 99th percentile tail latency: {highest_99th_percentile}")
    else:
        print("No data found in the file.")

if __name__ == "__main__":
    main()

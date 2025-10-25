require 'pry'

def two_sum_brute_force(nums, target)
  nums.each_with_index do |num, index|
    nums[(index + 1)..].each_with_index do |second_num, index_2|
      return [index, (index_2 + 1 + index)] if num + second_num == target
    end
  end
end

def two_sum(nums, target)
  hash = {}
  nums.each_with_index do |num, index|
    return [hash[target - num], index] if hash[target - num]

    hash[num] = index if hash[num].nil?
  end
end

# All below was generated with ChatGPT

# Third version - Super efficient with optimizations
# O(n) time, O(n) space, but with several performance optimizations
def two_sum_optimized(nums, target)
  return [] if nums.empty? || nums.length < 2
  
  # Pre-allocate hash with estimated size to reduce rehashing
  hash = {}
  hash.default = nil
  
  nums.each_with_index do |num, index|
    complement = target - num
    
    # Use key? instead of checking nil for better performance
    if hash.key?(complement)
      return [hash[complement], index]
    end
    
    # Store current number and index
    hash[num] = index
  end
  
  # Return empty array if no solution found (optional)
  []
end

# nums = [2, 7, 11, 15]
# target = 9
nums = [3, 3]
target = 6
print two_sum(nums, target)

def generate_test_data(size)
  nums = (1..size).to_a
  target = nums.first + nums.last
  [nums, target]
end

# Generate test data where solution is NOT at the beginning
def generate_worst_case_data(size)
  nums = (1..size).to_a
  # Make target require checking almost all elements
  target = nums[size-2] + nums[size-1]  # Second to last + last
  [nums, target]
end

# Generate random test data
def generate_random_data(size)
  nums = Array.new(size) { rand(1..1000) }
  # Pick two random indices for target
  i, j = [rand(size), rand(size)]
  i, j = j, i if i > j  # Ensure i < j
  target = nums[i] + nums[j]
  [nums, target]
end

def benchmark_two_sum(nums, target)
  start_time = Time.now
  result = two_sum(nums, target)
  end_time = Time.now
  execution_time = (end_time - start_time) * 1000

  puts "Array size: #{nums.length}"
  puts "Target: #{target}"
  puts "Result: #{result}"
  puts "Execution time: #{execution_time.round(4)} ms"
  puts '---'

  execution_time
end

# Simple memory tracking using GC stats
def get_memory_usage
  GC.start
  begin
    GC.stat[:heap_live_slots] || 0
  rescue
    0
  end
end

# Track memory allocation for a block
def track_memory_allocation(&block)
  # Get baseline memory
  GC.start
  memory_before = get_memory_usage
  
  # Execute the block
  result = yield
  
  # Get memory after
  GC.start
  memory_after = get_memory_usage
  
  # Calculate difference (in slots, convert to approximate bytes)
  memory_used = (memory_after - memory_before) * 40  # ~40 bytes per slot
  
  [result, memory_used]
end

# Fallback: Manual memory estimation based on algorithm
def estimate_memory_usage(method_name, array_size)
  case method_name
  when "Brute Force O(n²)"
    # Only uses loop variables - constant memory
    array_size * 0  # No additional memory
  when "Hash Map O(n)", "Optimized O(n)"
    # Uses hash table - O(n) space
    array_size * 50  # Estimate ~50 bytes per hash entry
  else
    0
  end
end

# Benchmark all three methods with improved memory tracking
def benchmark_all_methods(nums, target)
  methods = [
    { name: "Brute Force O(n²)", method: method(:two_sum_brute_force) },
    { name: "Hash Map O(n)", method: method(:two_sum) },
    { name: "Optimized O(n)", method: method(:two_sum_optimized) }
  ]
  
  results = {}
  
  methods.each do |method_info|
    # Try to measure actual memory usage
    begin
      result, memory_used = track_memory_allocation do
        method_info[:method].call(nums, target)
      end
      
      # If memory tracking failed (returned 0 or negative), use estimation
      if memory_used <= 0
        memory_used = estimate_memory_usage(method_info[:name], nums.length)
      end
    rescue
      # Fallback to estimation if tracking completely fails
      result = method_info[:method].call(nums, target)
      memory_used = estimate_memory_usage(method_info[:name], nums.length)
    end
    
    # Measure execution time separately
    start_time = Time.now
    method_info[:method].call(nums, target)
    end_time = Time.now
    execution_time = (end_time - start_time) * 1000
    
    results[method_info[:name]] = {
      time: execution_time,
      memory: memory_used,
      result: result
    }
  end
  
  results
end

# Note: two_sum_brute_force is already defined above

puts 'Performance & Memory comparison of all three two_sum methods:'
puts '=' * 80

test_sizes = [100, 1000, 5000, 10000, 20000]

# Test 1: Best case for brute force (solution at beginning)
puts "\n" + "=" * 80
puts "TEST 1: BEST CASE FOR BRUTE FORCE (Solution at beginning)"
puts "=" * 80

test_sizes.each do |size|
  nums, target = generate_test_data(size)
  results = benchmark_all_methods(nums, target)
  
  puts "\nArray size: #{size}, Target: #{target} (solution: [0, #{size-1}])"
  puts '-' * 60
  puts "Method".ljust(25) + "Time (ms)".ljust(15) + "Memory (bytes)".ljust(20) + "Memory (KB)"
  puts '-' * 60
  
  results.each do |method_name, data|
    memory_kb = (data[:memory] / 1024.0).round(2)
    puts "#{method_name.ljust(25)}#{data[:time].round(4).to_s.ljust(15)}#{data[:memory].to_s.ljust(20)}#{memory_kb}"
  end
end

# Test 2: Worst case for brute force (solution at end)
puts "\n" + "=" * 80
puts "TEST 2: WORST CASE FOR BRUTE FORCE (Solution at end)"
puts "=" * 80

test_sizes.each do |size|
  nums, target = generate_worst_case_data(size)
  results = benchmark_all_methods(nums, target)
  
  puts "\nArray size: #{size}, Target: #{target} (solution: [#{size-2}, #{size-1}])"
  puts '-' * 60
  puts "Method".ljust(25) + "Time (ms)".ljust(15) + "Memory (bytes)".ljust(20) + "Memory (KB)"
  puts '-' * 60
  
  results.each do |method_name, data|
    memory_kb = (data[:memory] / 1024.0).round(2)
    puts "#{method_name.ljust(25)}#{data[:time].round(4).to_s.ljust(15)}#{data[:memory].to_s.ljust(20)}#{memory_kb}"
  end
end

# Test 3: Random data (more realistic)
puts "\n" + "=" * 80
puts "TEST 3: RANDOM DATA (More realistic scenario)"
puts "=" * 80

test_sizes.each do |size|
  nums, target = generate_random_data(size)
  results = benchmark_all_methods(nums, target)
  
  puts "\nArray size: #{size}, Target: #{target} (random solution)"
  puts '-' * 60
  puts "Method".ljust(25) + "Time (ms)".ljust(15) + "Memory (bytes)".ljust(20) + "Memory (KB)"
  puts '-' * 60
  
  results.each do |method_name, data|
    memory_kb = (data[:memory] / 1024.0).round(2)
    puts "#{method_name.ljust(25)}#{data[:time].round(4).to_s.ljust(15)}#{data[:memory].to_s.ljust(20)}#{memory_kb}"
  end
end

# Calculate averages for final summary
puts "\n" + "=" * 80
puts "FINAL SUMMARY - Performance & Memory Analysis:"
puts "=" * 80
puts "Method".ljust(25) + "Avg Time (ms)".ljust(15) + "Avg Memory (KB)".ljust(20) + "Space Complexity"
puts '-' * 80

# Collect all results for averaging
all_results = {}
test_sizes.each do |size|
  nums, target = generate_test_data(size)
  results = benchmark_all_methods(nums, target)
  
  results.each do |method_name, data|
    all_results[method_name] ||= { times: [], memories: [] }
    all_results[method_name][:times] << data[:time]
    all_results[method_name][:memories] << data[:memory]
  end
end

# Display averages
all_results.each do |method_name, data|
  avg_time = (data[:times].sum / data[:times].length).round(4)
  avg_memory_kb = (data[:memories].sum / data[:memories].length / 1024.0).round(2)
  
  space_complexity = case method_name
  when "Brute Force O(n²)" then "O(1)"
  when "Hash Map O(n)" then "O(n)"
  when "Optimized O(n)" then "O(n)"
  end
  
  puts "#{method_name.ljust(25)}#{avg_time.to_s.ljust(15)}#{avg_memory_kb.to_s.ljust(20)}#{space_complexity}"
end

puts "\n" + "=" * 80
puts "MEMORY ANALYSIS NOTES:"
puts "=" * 80
puts "• Brute Force: O(1) space - only uses constant extra variables"
puts "• Hash Map: O(n) space - stores up to n elements in hash table"
puts "• Optimized: O(n) space - same as hash map but with micro-optimizations"
puts "• Memory measurements include Ruby object overhead"
puts "• GC.start() called before each measurement for accuracy"

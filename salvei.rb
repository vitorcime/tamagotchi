require "benchmark"

while true
  puts "ola"
  Benchmark.measure { sleep 10.0 }
end
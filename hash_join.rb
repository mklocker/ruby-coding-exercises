#!/usr/bin/env ruby

class HashJoin
  attr_accessor :arr1, :arr2, :storage1, :storage2

  def initialize
    #2 Sample arrays, each indicating a file with N values in it.
    #This should result in one match => 20
    @arr1 = 1..10_000
    @arr2 = 9_999..12_000
    @large_prime = 787
    @storage1 = Array.new(@large_prime)
    @storage2 = Array.new(@large_prime)
  end

  #Cross Join = O(n^2)
  def cross_join(array1 = @arr1, array2 = @arr2)
    array1.each do |id1|
      array2.each do |id2|
        if id1 == id2
          puts "Id #{id1} is matching both arrays"
        end
      end
    end
  end

  #Hash Join should be faster than Cross Join, but how fast?
  def hash_join
    #Parse both input arrays and group them as buckets in storage
    store(@arr1, storage1)
    store(@arr2, storage2)

    #Compare the 2 equivalent storage buckets and create cross join of them
    (0...@large_prime).each do |bucket|
      cross_join(@storage1[bucket], @storage2[bucket])
    end
  end

  def store(input_array, storage)
    input_array.each do |id1|
      bucket = id1 % @large_prime
      storage[bucket] = [] if storage[bucket].nil?
      storage[bucket] << id1
    end
  end
end


if __FILE__ == $0
  obj = HashJoin.new

  beginning = Time.now
  obj.cross_join
  puts "Time elapsed for cross join: #{Time.now - beginning} seconds."

  beginning = Time.now
  obj.hash_join
  puts "Time elapsed for hash join: #{Time.now - beginning} seconds."
end
require 'sha1'
require 'rubygems'
require 'bloomfilter'
filter = BloomFilter.new(100000000)
sha    = SHA1.digest('')
i = 0

loop do
  if filter.include?(sha)
    puts "collision at #{i}"
  end

  filter.add(sha) if   i % 10000 == 0
  p i             if i % 1000000 == 0
  sha  = SHA1.digest(sha)
  i+=1
end



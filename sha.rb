require 'sha1'
require 'rubygems'
require 'bloomfilter'
filter = BloomFilter.new(100)
sha    = SHA1.digest('')
i = 0

loop do
  if filter.include?(sha)
    raise "collision at #{i}"
  end

  filter.add(sha)
  sha  = SHA1.digest(sha)
  i+=1
end



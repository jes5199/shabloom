require 'sha1'
require 'rubygems'
require 'bloomfilter'
require 'pstore'

#filter = BloomFilter.new(100000000)
starter = ''
filter = BloomFilter.new(5000000)
sha    = SHA1.digest(starter)
i = 0
interesting = Hash.new(0)

period = 100000

hit_size = 1000
old_hits = BloomFilter.new(hit_size)
hits     = BloomFilter.new(hit_size)

loop do
  if filter.include?(sha)
    print "collision at #{i}"
    if old_hits.include?( (i - period).to_s )
      print " LOOKS INTERESTING"
      puts ""
      interesting[ i % period ] += 1
      if interesting[ i % period ] > 3
        raise "LOOKS REALLY INTERESTING"
      end
    end
    hits.add(i.to_s)
    puts ""
  end

  if i % period == 0
    old_hits = hits
    hits     = BloomFilter.new(hit_size)

    filter.add(sha) 
    p i
    if i % (period * 10)
      PStore.new('checkpoint').transaction do | s |
        s[:starter] = starter
        s[:sha]     = sha
        s[:i]       = i
      end
    end
  end

  sha  = SHA1.digest(sha)[0..7]
  i+=1
end



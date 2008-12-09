require 'sha1'
require 'md5'

COUNT = 12
start = SHA1.digest('')

bloom = "\x0" * ( (start.length) + (16 * COUNT) )

def bloom_add(filter, item)
  result   = ""
  filterIt = filter.bytes.each
  itemIt   = item.bytes.each

  begin
    loop do
      f = filterIt.next
      i = (itemIt.next rescue 0)
      result += (f | i).chr
    end
  rescue StopIteration
  end
  return result
end

def bloom_test(filter, item)

  filterIt = filter.bytes.each
  itemIt   = item.bytes.each

  begin
    loop do
      f = filterIt.next
      i = (itemIt.next rescue 0)
      return false if ( (~f) & i ) != 0
    end
  rescue StopIteration
  end
  return true
end

sha = start
i = 0

loop do
  bloomtest = sha
  COUNT.times do
    bloomtest += MD5.digest(bloomtest)
  end

  if bloom_test(bloom, bloomtest)
    raise "collision at #{i}"
  end

  bloom = bloom_add(bloom, bloomtest)
  sha  = SHA1.digest(sha)
  i+=1
end



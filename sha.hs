import Data.BloomFilter (insertB, elemB, emptyB)
import Data.BloomFilter.Hash (cheapHashes)
import Data.Digest.SHA1 (hash,Word160(Word160))
import Codec.Utils (toOctets)
import Debug.Trace (trace)

period   = 100000
hashSize = 9

shas i = h : (shas h)
    where h = toBytes160 $ hash i

toBytes160 (Word160 a b c d e) = concatMap (toOctets 256) $ [a,b,c,d,e]

testMany bloom pairs = answer ++ testMany newBloom toRecurse
    where (toTest,toRecurse) = splitAt period pairs
          toKeepPair  = last toTest
          traceToKeep = trace (show $ fst toKeepPair) $ snd toKeepPair
          answer   = filter (flip elemB bloom . snd) toTest
          newBloom = insertB traceToKeep bloom 

doTest hashes = testMany newBloom pairs
    where newBloom = emptyB (cheapHashes hashSize) (1024)
          pairs    = zip [1..] hashes

simpleTest = doTest $ cycle ([1..111] :: [Int])

doShas = doTest $ shas []

main = mapM_ print doShas

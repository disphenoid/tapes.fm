require 'rubygems'

class Autocomplete
  @scope = ""
  def initialize(complete_scope)
    
    @scope = complete_scope

  end  

  def add(tag)

    tag.downcase!
    tag.strip!
    (1..(tag.length)).each{|l|
        prefix = tag[0...l]
        REDIS.zadd(@scope,0,prefix)
    }
    REDIS.zadd(@scope,0,tag+"*")

  end
  def remove(tag)

    tag.downcase!
    tag.strip!

    REDIS.zrem(@scope,tag+"*")

  end  

  def complete(prefix,count=50)
      results = []
      rangelen = 50 # This is not random, try to get replies < MTU size
      start = REDIS.zrank(@scope,prefix)
      return [] if !start
      while results.length != count
          range = REDIS.zrange(@scope,start,start+rangelen-1)
          start += rangelen
          break if !range or range.length == 0
          range.each {|entry|
              minlen = [entry.length,prefix.length].min
              if entry[0...minlen] != prefix[0...minlen]
                  count = results.count
                  break
              end
              if entry[-1..-1] == "*" and results.length != count
                  results << entry[0...-1]
              end
          }
      end
      return results
  end

  def filter
    # implement a word filter "porn shit fuck bla"
  end


end

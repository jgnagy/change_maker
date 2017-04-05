module ChangeMaker
  class Calculation
    attr_reader   :total, :denominations

    def initialize(total, denominations)
      @total         = total
      @denominations = denominations.sort.reverse
      @cache         = {}
      @cache_hits    = 0
      @exact_matches = 0
      @cache_misses  = 0
    end

    # cache the list of possible coins
    def possible_coins
      @possible_coins ||= @denominations.select {|d| d <= @total }
    end

    def exact_match?
      @denominations.include?(@total)
    end

    def minimum(debug: false)
      return 1 if exact_match? # perfect match
      results = find(@total, possible_coins, debug)
      return -1 unless results # no results
      winner = results.sort {|r| r.size }.first
      puts "Results: #{winner}" if debug
      puts "Exact Matches: #{@exact_matches}" if debug
      puts "Cache Hits: #{@cache_hits}" if debug
      puts "Cache Misses: #{@cache_misses}" if debug
      winner.size
    end

    def find(value, range, debug = false)
      puts "Trying find(#{value}, [#{range.join(',')}])" if debug
      if range.include?(value)
        puts "Exact match found: #{value}" if debug
        @exact_matches += 1
        return [value]
      end

      cache_lookup = @cache["#{value}:#{range.join(',')}"]
      if cache_lookup
        puts "Cache Hit: #{value}:#{range.join(',')}" if debug
        @cache_hits += 1
        return cache_lookup
      end

      # Only increment when doing calculations
      @cache_misses += 1

      this_min = value + 1 # should not be possible

      possibilities = range.select {|d| d <= value }


      # TODO: make this not look like crap...
      collections = []
      possibilities.each do |coin|
        # check if the value is evenly divisible by this coin
        if value % coin == 0
          this_collection = [coin] * (value / coin)
          if this_collection.size < this_min
            this_min = this_collection.size
            collections << this_collection
            break # evenly divisible and smallest size, yay!
          else
            next  # while evenly divisible, not the smallest so on to next coin
          end
        elsif possibilities.include?(value % coin)
          this_collection = [coin] * (value / coin)
          this_collection << value % coin
          if this_collection.size < this_min
            this_min = this_collection.size
            collections << this_collection
            break
          else
            next
          end
        else
          # recurse on the remaining value after subtracting this coin
          result = find(value - coin, possibilities, debug)
          if result
            this_collection = [coin, result].flatten
            if this_collection.size < this_min
              this_min = this_collection.size
              collections << this_collection
            else
              next
            end
          end
        end
      end
      if collections.empty?
        nil
      else
        @cache["#{value}:#{range.join(',')}"] = collections
        collections
      end
    end
  end
end

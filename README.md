# ChangeMaker

A tool for combining denominations of "money" to reach a total, hopefully quickly. This tool attempts to find the optimal solution, though I'm not certain it can be proved that it actually provides the optimal solution (other than brute force for every problem). I might be wrong.

## Installation

To install this gem onto your local machine, run `bundle exec rake install`.

## Usage

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

```ruby
include ChangeMaker

desired_total = 99
denominations = [25, 10, 5, 1]
calc = Calculation.new(desired_total, denominations)
calc.minimum # => 9
```

Calculations make use of an internal cache (keyed off of a temporary desired value and the list of possible denominations for that value), and use recursion to find solutions. It also makes use of a couple simple tricks to speed things up based on moduli and exact matches. To see how these are used, the `#minumum` method supports a debug option:

```ruby
calc = Calculation.new(23, [25, 10, 5, 1])
calc.minimum(debug: true) # => 5
```

will print:

```
Trying find(23, [10,5,1])
Trying find(13, [10,5,1])
Trying find(3, [10,5,1])
Trying find(8, [10,5,1])
Trying find(3, [5,1])
Trying find(18, [10,5,1])
Trying find(8, [10,5,1])
Cache Hit: 8:10,5,1
Trying find(13, [10,5,1])
Cache Hit: 13:10,5,1
Results: [10, 10, 1, 1, 1]
Exact Matches: 0
Cache Hits: 2
Cache Misses: 6
```

## Contributing

This is just for the author's enjoyment. Pull requests will, most likely, be completely ignored.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

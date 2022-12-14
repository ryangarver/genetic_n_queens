# Attempt to solve the N queens problem using a genetic algorithm.
# Usage: `ruby genetic_n_queens.rb`
# See Config.help() for command line options

require_relative 'lib/config'
require_relative 'lib/solution'

Config.parse_options(ARGV.each_slice(2).to_h) rescue Config.help()
Solution.solve()

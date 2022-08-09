# GeneticNQueens

This is a Ruby implementation of a genetic algorithm to solve the
[N Queens Problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle)

## Usage

`ruby genetic_n_queens.rb`

Defaults to 8-queens (standard chess board)

Options:
```
-n
  Select an alternate board size, e.g. n=10.  Default 8
--pop
  The number of solutions in a population.  Default 1000
--max
  The maximum number of generations to try and find a solution.  This will
  need to be increased for larger N values.  Default 50
--mutation_rate
  The percentage of new child Solutions that have one gene (i.e. queen position)
  changed randomly.  Default 0.05
--replacement_rate
  The percentage of each solution generation that is replaced by child
  solutions vs keeping fit ancestors
```

## Author

Ryan Garver rgarver@terakeet.com

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

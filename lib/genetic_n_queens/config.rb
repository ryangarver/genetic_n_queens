# frozen_string_literal: true
class Config

  # Defaults
  @@n = 8
  @@population = 1000
  @@max_generations = 50
  @@mutation_rate = 0.05
  @@replacement_rate = 0.75

  def self.help()
    puts """
    Genetic N Queens Solver
    usage `ruby genetic_n_queens.rb` Defaults to 8-queens (standard chess board)
    options:
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
    """
    exit()
  end

  # Parse an option hash (i.e. from ARGV.each_slice(2).to_h) and set global config
  def self.parse_options(opts)
    opts.each do |k,v|
      case k
      when '-h'
        help()
      when '--help'
        help()
      when '-n'
        @@n = v.to_i
      when '--pop'
        @@population = v.to_i
      when '--max'
        @@max_generations = v.to_i
      when '--mutation_rate'
        @@mutation_rate = v.to_f
      when '--replacement_rate'
        @@replacement_rate = v.to_f
      else
        puts "Invalid option '#{k}'\n\n"
        help()
      end
    end
  end

  # The size of the chess board.  A standard board is 8 squares per side.
  def self.n()
    @@n
  end

  # The number of solutions in a population
  def self.population()
    @@population
  end

  # The maximum number of generations to find a solution, otherwise halt
  def self.max_generations()
    @@max_generations
  end

  # The percentage 0.0-1.0 of solutions to mutate each generation
  def self.mutation_rate()
    @@mutation_rate
  end

  # The percentage 0.0-1.0 to replace each generation with new children versus
  # keeping fit ancestors
  def self.replacement_rate()
    @@replacement_rate
  end
end

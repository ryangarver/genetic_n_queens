# frozen_string_literal: true
require_relative 'config'

# A Solution represents a (possible) solution to the N queens problem.  its
# internal data is an array representing the position of a queen
# in each file (assuming one queen per rank).  The quality of the solution
# is scored by a fitness value from 0.0 - 1.0, with a 1.0 indicating
# a correct solution.  New solutions can be 'bred' by combining elements (genes)
# from two parents.
class Solution

  # Init a solution.  If the parents are both nil, it will be a random one, otherwise
  # breed a solution from the parents
  def initialize(parent_1=nil, parent_2=nil)
    @n = Config.n()
    if parent_1.nil? || parent_2.nil?
      @matrix = @n.times.map {rand(@n)}
    else # Breed a solution from the two parents
      crossover = 1 + rand(@n-2) # crossover index determines how many genes to take from P1 vs P2
      @matrix = @n.times.map do |i|
        i < crossover ? parent_1[i] : parent_2[i]
      end
    end
  end

  # Return the underlying solution data, which is an array of size N representing
  # the rank of each queen in a file.
  def matrix()
    @matrix
  end

  # Manually set the underlying solution data
  def matrix=(m)
    @matrix = m
  end

  # Access the position of the queen in a given file for this Solution
  def [](key)
    @matrix[key]
  end

  # Randomly change one gene in this Solution, and return self
  def mutate()
    @matrix[rand(@n)] = rand(@n)
    @fitness = nil
    self
  end

  # Determine the fitness of this solution on a 0.0-1.0 scale, with a 1.0 being
  # a correct solution.
  def fitness()
    # Fitness is determined by percentage of safe queens
    return @fitness if @fitness
    safe_queens = 0
    rank_counts = Hash.new(0)
    diag_1_counts = Hash.new(0)
    diag_2_counts = Hash.new(0)
    @matrix.each_with_index do |x, y|
      rank_counts[x] += 1
      diag_1_counts[diag(x,y)] += 1
      diag_2_counts[diag(x,-y)] += 1
    end
    @matrix.each_with_index do |x, y|
      # Check if each queen is the only one on its rank and both diagnoals (files are implied to be 1 by the solution structure)
      if [rank_counts[x], diag_1_counts[diag(x,y)], diag_2_counts[diag(x, -y)]].all?{|c| c == 1}
        safe_queens += 1
      end
    end
    @fitness = safe_queens.to_f / @n
  end

  # Return true if this is a correct solution to the N queens problem (all queens are safe)
  def correct?
    fitness() == 1
  end

  # Given an x,y coordinate return the index of the diagonal it sits on.
  # To calculate the diagonals slanting in the other direction, call diag(x, -y)
  def diag(x, y)
    x - y + @n - 1
  end

  # Return a string representing this Solution on a chess board
  def to_board()
    result = "╔#{'═' * @n }╗\n"
    @n.times do |i|
      row = "║#{(i.even? ? '▫▪' : '▪▫') * (@n / 2)}║\n"
      row[@matrix[i]+1] = "\e[35m♕\e[0m"
      result += row
    end
    result += "╚#{'═' * @n }╝"
    result
  end

  # Sort in descending order of fitness (best first)
  def <=>(other)
    other.fitness() <=> fitness()
  end

  # Return the chess board and fitness
  def to_s()
    to_board() + "\nFitness: #{fitness()}"
  end

  # Select two parents at random.  Use a weighted lottery (weighted by fitness)
  def self.select_parents(sorted_pop, fitness_sum)
    ball_1, ball_2 = [(rand() * fitness_sum), (rand() * fitness_sum)].sort
    parent_1 = nil
    running_total = 0
    sorted_pop.each do |s|
      running_total += s.fitness
      parent_1 = s if parent_1.nil? && (running_total >= ball_1)
      return [parent_1, s] if running_total >= ball_2
    end
    raise "Logic error, shouldn't get here"
  end

  # Attempt to solve the N queens problem.  Returns a correct Solution or nil
  def self.solve()
    # initialize the population with all random Solutions
    pop = Config.population().times.map{ Solution.new() }.sort
    best = nil
    Config.max_generations.times do |gen|
      fitness_sum = pop.sum{|s| s.fitness}
      puts "Generation #{gen}: Best #{pop.first.fitness.round(3)}, Avg #{(fitness_sum / pop.size.to_f).round(3)}"
      # Subject to the replacement rate, start the new generation with the fittest Solutions
      new_pop = pop.take(((1 - Config.replacement_rate()) * pop.size).to_i)
      # Breed new solutions by randomly pairing parents, selected from a lottery weighted by fitness
      (Config.population() - new_pop.size()).times do
        p1, p2 = select_parents(pop, fitness_sum)
        child = Solution.new(p1, p2)
        # Some percentage of children will be mutated by one gene (i.e. one queen position)
        child.mutate() if Config.mutation_rate() > rand()
        new_pop << child
      end
      pop = new_pop.sort
      best = pop.first
      if best.correct?
        puts "Solved!"
        break
      end
    end
    puts best.to_s
    puts "(Failed to find a solution)" unless best.correct?
    best
  end
end

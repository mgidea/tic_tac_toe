class Board
  attr_accessor :size, :rows, :columns, :diagonals, :players, :values
  VALUES = ["X", "Y"]
  def initialize(size = 3)
    self.size = size
    self.rows = []
    self.size.times { |i| rows << Row.new(self, i) }
    self.columns = (0...size).to_a.map { |index| Column.new(index, self) }
    self.diagonals = [0, size -1].map { |index| Diagonal.new(index, self) }
    self.players = []
    self.values = ["X", "O"]
  end

  def get_player(name)
    unless values.empty?
      players.push(Player.new(name, values.pop))
    end
  end

  def self.start_game
    puts "Let's get started"
    board = new
    puts
    puts "What is player one's name?"
    board.get_player(gets.chomp)
    puts "Hi #{board.players.first.name}."
    puts
    puts "What is player two's name?"
    board.get_player(gets.chomp)
    puts
    puts "Hi #{board.players.last.name}."
    board
  end

  def play
    player_index = 0
    puts "Time to get started"
    until winner?
      player = players[player_index]
      display
      puts "#{player.name}, It's your move, which number would you like to put your #{player.value} on?"
      choice = gets.chomp.to_i
      unless choice.to_s.match(/\d/) && self[choice].to_s.match(/d/)
        self[choice] = player.value
        player_index = (player_index == 0) ? 1 : 0 unless winner?
      end
    end
    puts "#{player.name} is the winner, nice work!"
    return
  end

  def display
    puts "-" * 15
    rows.each(&:display)
    puts "-" * 15
  end

  def inspect
    rows.map(&:row).inspect
  end

  def []=(val, place)
    num = val.to_i
    index = (num - 1) / size
    col = (num - 1) % size
    to_a[index][col] = place
    display
  end

  def [](val)
    num = val.to_i
    index = (num - 1) / size
    col = (num - 1) % size
    to_a[index][col]
  end

  def to_a
    rows.map(&:to_a)
  end

  def winner?
    [rows, columns, diagonals].flatten.any?(&:winner?)
  end
end

class Row
  attr_accessor :row, :index, :board

  def initialize(board, index)
    self.row = []
    self.index = index
    board.size.times do |i|
      number = i + 1
      base = (index) * board.size
      self.row.push(number + base)
    end
  end

  def display
    puts "| #{row.join(" | ")} |"
  end

  def to_a
    row
  end

  def winner?
    row[1..-1].all?{|i| i == row[0]}
  end
end

class Column
  attr_accessor :index, :rows, :board
  def initialize(index, board)
    self.board = board
    self.rows = board.rows
    self.index = index
  end

  def column
    rows.map {|row| row.row[index]}
  end

  def winner?
    column[1..-1].all?{|i| i == column[0]}
  end

  def to_a
    column
  end
end

class Diagonal
  attr_accessor :start_index, :end_index, :board
  def initialize(start_index, board)
    self.start_index = start_index
    self.board = board
    self.end_index = start_index == 0 ? board.size - 1 : 0
  end

  def diagonal
    count = start_index
    board.rows.map do |row|
      item = row.row[count]
      start_index.zero? ? count += 1 : count -= 1
      item
    end
  end

  def winner?
    diagonal[1..-1].all?{|i| i == diagonal[0]}
  end

  def to_a
    diagonal
  end
end

class Player
  attr_accessor :name, :value
  def initialize(name, value)
    self.name = name
    self.value = value
  end
end

board = Board.start_game

board.play


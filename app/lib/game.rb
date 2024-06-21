class Game
    attr_reader :board
  
    def start(cells)
      @board = Board.create(cells: cells)
      self
    end
  
    def load(id)
      @board = Board.find(id)
      self
    end
  
    def next_state
      new_state = iterate(@board.cells)
      @board.update(cells: new_state)
    end
  
    def state(n = 1)
      new_state = @board.cells
      for i in 1..n do
        new_state = iterate(new_state)
      end
      @board.update(cells: new_state)
    end
  
    def final_state(max_attemps = 10)
      new_state = @board.cells
      prev_state = @board.cells
      count = 0
  
      loop do
        raise GameExceptions::MaximumAttempts if (count > max_attemps)
        prev_state = new_state
        new_state = iterate(prev_state)
        count += 1
        break if (prev_state == new_state)
      end
  
      @board.update(cells: new_state)
    end
  
    def reset
      @board.update(cells: @board.original_seed)
    end
  
    private
  
    def iterate(grid)
      new_grid = []
      grid.each_with_index do |row, y|
        new_row = []
        row.each_with_index do |cell, x|
          new_row << apply_rules(cell, count_neighbours(x, y, grid))
        end
        new_grid << new_row
      end
      new_grid
    end
  
    def count_neighbours(x, y, grid)
      neighbours = 0
      neighbours += grid[y][x - 1] if x - 1 >= 0
      neighbours += grid[y - 1][x] if y - 1 >= 0
      neighbours += grid[y][x + 1] if x + 1 < grid[y].size
      neighbours += grid[y + 1][x] if y + 1 < grid.size
      neighbours
    end
  
    def apply_rules(cell, neighbours)
      return 1 if cell == 0 && neighbours == 3
      return 0 if cell == 1 && (neighbours < 2 || neighbours > 3)
      cell
    end
  end
  
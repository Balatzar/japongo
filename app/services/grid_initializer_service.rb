class GridInitializerService
  GRID_SIZE = 30

  def initialize(enable_logging: false)
    @enable_logging = enable_logging
  end

  def initialize_grid
    Array.new(GRID_SIZE) { Array.new(GRID_SIZE, " ") }
  end

  def clean_grid(grid)
    log "Cleaning grid..."
    log "Original grid size: #{grid.size}x#{grid[0].size}"

    first_non_empty_row = grid.index { |row| row.any? { |cell| cell != " " } }
    last_non_empty_row = grid.rindex { |row| row.any? { |cell| cell != " " } }

    transposed_grid = grid.transpose
    first_non_empty_col = transposed_grid.index { |col| col.any? { |cell| cell != " " } }
    last_non_empty_col = transposed_grid.rindex { |col| col.any? { |cell| cell != " " } }

    cleaned_grid = grid[first_non_empty_row..last_non_empty_row].map do |row|
      row[first_non_empty_col..last_non_empty_col]
    end

    log "Cleaned grid size: #{cleaned_grid.size}x#{cleaned_grid[0].size}"

    cleaned_grid
  end

  def print_grid(grid)
    grid.each do |row|
      log row.map { |cell| cell == " " ? "." : cell }.join
    end
  end

  private

  def log(message)
    pp message if @enable_logging
  end
end
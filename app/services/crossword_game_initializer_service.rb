class CrosswordGameInitializerService
  GRID_SIZE = 30
  WORDS_TO_PLACE = 10

  @@all_words = {}

  def self.initialize_game
    @@all_words = Word.all.index_by(&:romanji)
    words = @@all_words.values.sample(50)
    biggest_word = words.max_by { |word| word.romanji.length }
    grid = initialize_grid
    placed_words = [ biggest_word ]
    place_biggest_word(grid, biggest_word)

    while placed_words.size < WORDS_TO_PLACE
      word_to_place = find_intersecting_word(words - placed_words, placed_words)
      pp word_to_place
      break unless word_to_place

      if place_word(grid, word_to_place, placed_words)
        placed_words << word_to_place
      end
    end

    {
      words: words,
      placed_words: placed_words,
      grid: grid
    }
  end

  def self.check_grid(grid)
    # Check horizontal words
    grid.each do |row|
      pp "row: #{row.join}"
      return false unless check_words_in_line(row.join)
    end

    # Check vertical words
    GRID_SIZE.times do |col|
      vertical_line = grid.map { |row| row[col] }.join
      return false unless check_words_in_line(vertical_line)
    end

    true
  end

  private

  def self.check_words_in_line(line)
    line.split(" ").each do |word_candidate|
      pp word_candidate
      next if word_candidate.length <= 1
      unless @@all_words.key?(word_candidate)
        return false
      end
    end
    true
  end

  def self.initialize_grid
    Array.new(GRID_SIZE) { Array.new(GRID_SIZE, " ") }
  end

  def self.place_biggest_word(grid, word)
    word_length = word.romanji.length
    start_row = GRID_SIZE / 2
    start_col = (GRID_SIZE - word_length) / 2

    word.romanji.each_char.with_index do |char, index|
      grid[start_row][start_col + index] = char
    end
  end

  def self.find_intersecting_word(words, placed_words)
    placed_chars = placed_words.flat_map { |word| word.romanji.chars }.uniq
    words.find do |word|
      (word.romanji.chars & placed_chars).any?
    end
  end

  def self.place_word(grid, word, placed_words)
    placed_chars = placed_words.flat_map { |w| w.romanji.chars }.uniq
    common_chars = word.romanji.chars & placed_chars

    common_chars.each do |common_char|
      word_index = word.romanji.index(common_char)

      GRID_SIZE.times do |row|
        GRID_SIZE.times do |col|
          if grid[row][col] == common_char
            if can_place_horizontally?(grid, word, row, col - word_index)
              place_horizontally(grid, word, row, col - word_index)
              return true
            elsif can_place_vertically?(grid, word, row - word_index, col)
              place_vertically(grid, word, row - word_index, col)
              return true
            end
          end
        end
      end
    end

    false
  end

  def self.can_place_horizontally?(grid, word, row, start_col)
    return false if start_col < 0 || start_col + word.romanji.length > GRID_SIZE

    word.romanji.each_char.with_index do |char, index|
      col = start_col + index
      return false if grid[row][col] != " " && grid[row][col] != char
    end

    true
  end

  def self.can_place_vertically?(grid, word, start_row, col)
    return false if start_row < 0 || start_row + word.romanji.length > GRID_SIZE

    word.romanji.each_char.with_index do |char, index|
      row = start_row + index
      return false if grid[row][col] != " " && grid[row][col] != char
    end

    true
  end

  def self.place_horizontally(grid, word, row, start_col)
    word.romanji.each_char.with_index do |char, index|
      grid[row][start_col + index] = char
    end
  end

  def self.place_vertically(grid, word, start_row, col)
    word.romanji.each_char.with_index do |char, index|
      grid[start_row + index][col] = char
    end
  end
end

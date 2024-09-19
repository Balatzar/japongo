class CrosswordGameInitializerService
  GRID_SIZE = 30
  WORDS_TO_PLACE = 10

  @@all_words = {}

  def self.initialize_game
    @@all_words = Word.all.index_by(&:romanji)
    words = @@all_words.values.sample(400)
    biggest_word = words.max_by { |word| word.romanji.length }
    pp "biggest_word: #{biggest_word.romanji.inspect}"
    grid = initialize_grid
    placed_words = [ biggest_word ]
    place_biggest_word(grid, biggest_word)
    pp grid

    maximum = 50
    i = 0

    while placed_words.size < WORDS_TO_PLACE
      word_to_place = find_intersecting_word(words - placed_words, placed_words)
      pp "word_to_place: #{word_to_place.romanji.inspect}"
      break unless word_to_place
      break if i > maximum
      i += 1

      if place_word(grid, word_to_place, placed_words, words)
        pp "Word has been placed"
        pp grid
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
      return false unless check_words_in_line(row.join)
    end

    # Check vertical words
    grid.length.times do |col|
      vertical_line = grid.map { |row| row[col] }.join
      return false unless check_words_in_line(vertical_line)
    end

    true
  end

  private

  def self.check_words_in_line(line)
    line.split(" ").each do |word_candidate|
      next if word_candidate.length <= 1
      pp @@all_words
      unless @@all_words.key?(word_candidate)
        pp "Word not found: #{word_candidate.inspect}"
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
    start_row = grid.length / 2
    start_col = (grid.length - word_length) / 2

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

  def self.place_word(grid, word, placed_words, words)
    placed_chars = placed_words.flat_map { |w| w.romanji.chars }.uniq
    common_chars = word.romanji.chars & placed_chars
    pp "common_chars: #{common_chars.inspect}"

    common_chars.each do |common_char|
      word_index = word.romanji.index(common_char)
      pp "word_index: #{word_index.inspect}"

      grid.length.times do |row|
        grid.length.times do |col|
          if grid[row][col] == common_char
            pp "common_char: #{common_char.inspect}"
            pp "row: #{row.inspect}, col: #{col.inspect}"
            if can_place_horizontally?(grid, word, row, col - word_index)
              place_horizontally(grid, word, row, col - word_index)
              if check_grid(grid)
                return true
              else
                remove_horizontally(grid, word, row, col - word_index, col)
                words.delete(word)
              end
            elsif can_place_vertically?(grid, word, row - word_index, col)
              pp "We can place vertically"
              place_vertically(grid, word, row - word_index, col)
              if check_grid(grid)
                return true
              else
                pp "The grid was invalid"
                pp grid
                remove_vertically(grid, word, row - word_index, col, row)
                words.delete(word)
              end
            end
          end
        end
      end
    end

    false
  end

  def self.can_place_horizontally?(grid, word, row, start_col)
    return false if start_col < 0 || start_col + word.romanji.length > grid.length

    word.romanji.each_char.with_index do |char, index|
      col = start_col + index
      return false if grid[row][col] != " " && grid[row][col] != char
    end

    true
  end

  def self.can_place_vertically?(grid, word, start_row, col)
    return false if start_row < 0 || start_row + word.romanji.length > grid.length

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

  def self.remove_horizontally(grid, word, row, start_col, initial_col)
    word.romanji.length.times do |index|
      grid[row][start_col + index] = " " unless start_col + index == initial_col # Don't remove the intersecting character
    end
  end

  def self.remove_vertically(grid, word, start_row, col, initial_row)
    word.romanji.length.times do |index|
      grid[start_row + index][col] = " " unless start_row + index == initial_row # Don't remove the intersecting character
    end
  end
end

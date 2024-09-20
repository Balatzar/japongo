class WordPlacementService
  def initialize(use_hiragana: true, enable_logging: false, grid_validation: nil)
    @use_hiragana = use_hiragana
    @enable_logging = enable_logging
    @grid_validation = grid_validation
  end

  def place_biggest_word(grid, word)
    word_length = word_field(word).length
    start_row = grid.length / 2
    start_col = (grid.length - word_length) / 2

    word_field(word).each_char.with_index do |char, index|
      grid[start_row][start_col + index] = char
    end

    [ start_row, start_col ]
  end

  def find_intersecting_word(words, placed_words)
    placed_chars = placed_words.flat_map { |word| word_field(word).chars }.uniq
    words.find do |word|
      (word_field(word).chars & placed_chars).any?
    end
  end

  def place_word(grid, word, placed_words, words)
    placed_chars = placed_words.flat_map { |w| word_field(w).chars }.uniq
    common_chars = word_field(word).chars & placed_chars
    log "common_chars: #{common_chars.inspect}"

    common_chars.each do |common_char|
      word_index = word_field(word).index(common_char)
      log "word_index: #{word_index.inspect}"

      grid.length.times do |row|
        grid.length.times do |col|
          if grid[row][col] == common_char
            log "common_char: #{common_char.inspect}"
            log "row: #{row.inspect}, col: #{col.inspect}"
            if can_place_horizontally?(grid, word, row, col - word_index)
              log "We can place horizontally"
              place_horizontally(grid, word, row, col - word_index)
              if @grid_validation.check_grid(grid)
                log "The grid was valid"
                return { direction: "horizontal", start: [ row, col - word_index ] }
              else
                log "The grid was invalid"
                log grid
                remove_horizontally(grid, word, row, col - word_index, col)
                words.delete(word)
              end
            elsif can_place_vertically?(grid, word, row - word_index, col)
              log "We can place vertically"
              place_vertically(grid, word, row - word_index, col)
              if @grid_validation.check_grid(grid)
                log "The grid was valid"
                return { direction: "vertical", start: [ row - word_index, col ] }
              else
                log "The grid was invalid"
                log grid
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

  def can_place_horizontally?(grid, word, row, start_col)
    return false if start_col < 0 || start_col + word_field(word).length > grid.length

    word_field(word).each_char.with_index do |char, index|
      col = start_col + index
      return false if grid[row][col] != " " && grid[row][col] != char
    end

    true
  end

  def can_place_vertically?(grid, word, start_row, col)
    return false if start_row < 0 || start_row + word_field(word).length > grid.length

    word_field(word).each_char.with_index do |char, index|
      row = start_row + index
      return false if grid[row][col] != " " && grid[row][col] != char
    end

    true
  end

  def place_horizontally(grid, word, row, start_col)
    word_field(word).each_char.with_index do |char, index|
      grid[row][start_col + index] = char unless grid[row][start_col + index] != " "
    end
  end

  def place_vertically(grid, word, start_row, col)
    word_field(word).each_char.with_index do |char, index|
      grid[start_row + index][col] = char unless grid[start_row + index][col] != " "
    end
  end

  def remove_horizontally(grid, word, row, start_col, initial_col)
    word_field(word).length.times do |index|
      grid[row][start_col + index] = " " unless start_col + index == initial_col
    end
  end

  def remove_vertically(grid, word, start_row, col, initial_row)
    word_field(word).length.times do |index|
      grid[start_row + index][col] = " " unless start_row + index == initial_row
    end
  end

  private

  def word_field(word)
    @use_hiragana ? word.hiragana : word.romanji
  end

  def log(message)
    pp message if @enable_logging
  end
end

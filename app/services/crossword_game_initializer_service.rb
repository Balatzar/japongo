class CrosswordGameInitializerService
  GRID_SIZE = 30

  attr_reader :word_dictionary, :words, :words_to_place, :use_hiragana, :enable_logging, :existing_grid

  def initialize(word_dictionary: nil, words: nil, words_to_place: 10, use_hiragana: true, enable_logging: false, existing_grid: nil)
    @use_hiragana = use_hiragana
    @enable_logging = enable_logging
    @word_dictionary = word_dictionary || Word.all.index_by { |word| word_field(word) }
    @words = words || Word.all.sample(2_000)
    @words_to_place = words_to_place
    @existing_grid = existing_grid
  end

  def run
    grid = @existing_grid ? @existing_grid.map(&:dup) : initialize_grid
    placed_words = []
    word_placements = {}

    if @existing_grid
      log "Using existing grid:"
      print_grid(grid)
      existing_words = extract_words_from_grid(grid)
      log "Existing words: #{existing_words.inspect}"
      placed_words.concat(existing_words)
      existing_words.each do |word|
        word_placements[word] = find_word_placement(grid, word)
      end
    else
      biggest_word = words.max_by { |word| word_field(word).length }
      log "biggest_word: #{word_field(biggest_word).inspect}"
      start_row, start_col = place_biggest_word(grid, biggest_word)
      placed_words << biggest_word
      word_placements[biggest_word] = { direction: "horizontal", start: [ start_row, start_col ] }
      log grid
    end

    maximum = 1_000
    i = 0

    while placed_words.size <= words_to_place
      word_to_place = find_intersecting_word(words - placed_words, placed_words)
      break unless word_to_place
      log "word_to_place: #{word_field(word_to_place).inspect}"
      break if i > maximum
      i += 1

      placement = place_word(grid, word_to_place, placed_words, words)
      if placement
        log "Word has been placed"
        log grid
        placed_words << word_to_place
        word_placements[word_to_place] = placement
      end
    end

    log "Original grid:"
    print_grid(grid)

    cleaned_grid = clean_grid(grid)

    log "Cleaned grid:"
    print_grid(cleaned_grid)

    clues = generate_clues(placed_words, word_placements, grid, cleaned_grid)

    {
      placed_words: placed_words,
      grid: cleaned_grid,
      clues: clues
    }
  end

  def check_grid(grid)
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

  def log(message)
    pp message if @enable_logging
  end

  def word_field(word)
    use_hiragana ? word.hiragana : word.romanji
  end

  def check_words_in_line(line)
    line.split(" ").each do |word_candidate|
      next if word_candidate.length <= 1
      unless word_dictionary.key?(word_candidate)
        log "Word not found: #{word_candidate.inspect}"
        return false
      end
    end
    true
  end

  def initialize_grid
    Array.new(GRID_SIZE) { Array.new(GRID_SIZE, " ") }
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
              if check_grid(grid)
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
              if check_grid(grid)
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
      grid[row][start_col + index] = " " unless start_col + index == initial_col # Don't remove the intersecting character
    end
  end

  def remove_vertically(grid, word, start_row, col, initial_row)
    word_field(word).length.times do |index|
      grid[start_row + index][col] = " " unless start_row + index == initial_row # Don't remove the intersecting character
    end
  end

  def clean_grid(grid)
    log "Cleaning grid..."
    log "Original grid size: #{grid.size}x#{grid[0].size}"

    # Find the first and last non-empty rows
    first_non_empty_row = grid.index { |row| row.any? { |cell| cell != " " } }
    last_non_empty_row = grid.rindex { |row| row.any? { |cell| cell != " " } }

    # Find the first and last non-empty columns
    transposed_grid = grid.transpose
    first_non_empty_col = transposed_grid.index { |col| col.any? { |cell| cell != " " } }
    last_non_empty_col = transposed_grid.rindex { |col| col.any? { |cell| cell != " " } }

    # Slice the grid to keep only non-empty rows and columns
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

  def generate_clues(placed_words, word_placements, original_grid, cleaned_grid)
    row_offset = original_grid.index { |row| row.any? { |cell| cell != " " } } || 0
    col_offset = original_grid.transpose.index { |col| col.any? { |cell| cell != " " } } || 0

    placed_words.map do |word|
      placement = word_placements[word]
      original_start = placement[:start]
      cleaned_start = [
        original_start[0] - row_offset,
        original_start[1] - col_offset
      ]

      {
        word: word_field(word),
        direction: placement[:direction],
        starting_index: cleaned_start
      }
    end
  end

  def extract_words_from_grid(grid)
    words = []
    # Extract horizontal words
    grid.each do |row|
      words.concat(extract_words_from_line(row.join))
    end
    # Extract vertical words
    grid.transpose.each do |col|
      words.concat(extract_words_from_line(col.join))
    end
    words.uniq.map { |word| word_dictionary[word] }
  end

  def extract_words_from_line(line)
    line.split(" ").select { |word| word.length > 1 && word_dictionary.key?(word) }
  end

  def find_word_placement(grid, word)
    grid.each_with_index do |row, row_index|
      col_index = row.join.index(word_field(word))
      return { direction: "horizontal", start: [ row_index, col_index ] } if col_index
    end
    grid.transpose.each_with_index do |col, col_index|
      row_index = col.join.index(word_field(word))
      return { direction: "vertical", start: [ row_index, col_index ] } if row_index
    end
    nil
  end
end

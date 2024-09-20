class CrosswordGameInitializerService
  GRID_SIZE = 30

  attr_reader :word_dictionary, :words, :words_to_place, :use_hiragana

  def initialize(word_dictionary: nil, words: nil, words_to_place: 10, use_hiragana: true)
    @use_hiragana = use_hiragana
    @word_dictionary = word_dictionary || Word.all.index_by { |word| word_field(word) }
    @words = words || Word.all.sample(2_000)
    @words_to_place = words_to_place
  end

  def run
    biggest_word = words.max_by { |word| word_field(word).length }
    pp "biggest_word: #{word_field(biggest_word).inspect}"
    grid = initialize_grid
    placed_words = []
    word_placements = {}

    start_row, start_col = place_biggest_word(grid, biggest_word)
    placed_words << biggest_word
    word_placements[biggest_word] = { direction: "horizontal", start: [ start_row, start_col ] }
    pp grid

    maximum = 1_000
    i = 0

    while placed_words.size < words_to_place
      word_to_place = find_intersecting_word(words - placed_words, placed_words)
      pp "word_to_place: #{word_field(word_to_place).inspect}"
      break unless word_to_place
      break if i > maximum
      i += 1

      placement = place_word(grid, word_to_place, placed_words, words)
      if placement
        pp "Word has been placed"
        pp grid
        placed_words << word_to_place
        word_placements[word_to_place] = placement
      end
    end

    pp "Original grid:"
    print_grid(grid)

    cleaned_grid = clean_grid(grid)

    pp "Cleaned grid:"
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

  private

  def word_field(word)
    use_hiragana ? word.hiragana : word.romanji
  end

  def check_words_in_line(line)
    line.split(" ").each do |word_candidate|
      next if word_candidate.length <= 1
      unless word_dictionary.key?(word_candidate)
        pp "Word not found: #{word_candidate.inspect}"
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
    pp "common_chars: #{common_chars.inspect}"

    common_chars.each do |common_char|
      word_index = word_field(word).index(common_char)
      pp "word_index: #{word_index.inspect}"

      grid.length.times do |row|
        grid.length.times do |col|
          if grid[row][col] == common_char
            pp "common_char: #{common_char.inspect}"
            pp "row: #{row.inspect}, col: #{col.inspect}"
            if can_place_horizontally?(grid, word, row, col - word_index)
              place_horizontally(grid, word, row, col - word_index)
              if check_grid(grid)
                return { direction: "horizontal", start: [ row, col - word_index ] }
              else
                remove_horizontally(grid, word, row, col - word_index, col)
                words.delete(word)
              end
            elsif can_place_vertically?(grid, word, row - word_index, col)
              pp "We can place vertically"
              place_vertically(grid, word, row - word_index, col)
              if check_grid(grid)
                return { direction: "vertical", start: [ row - word_index, col ] }
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
      grid[row][start_col + index] = char
    end
  end

  def place_vertically(grid, word, start_row, col)
    word_field(word).each_char.with_index do |char, index|
      grid[start_row + index][col] = char
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
    pp "Cleaning grid..."
    pp "Original grid size: #{grid.size}x#{grid[0].size}"

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

    pp "Cleaned grid size: #{cleaned_grid.size}x#{cleaned_grid[0].size}"

    cleaned_grid
  end

  def print_grid(grid)
    grid.each do |row|
      puts row.map { |cell| cell == " " ? "." : cell }.join
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
end

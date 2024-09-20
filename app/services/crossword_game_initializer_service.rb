require_relative "grid_initializer_service"
require_relative "word_placement_service"
require_relative "grid_validation_service"
require_relative "clue_generator_service"

class CrosswordGameInitializerService
  attr_reader :word_dictionary, :words, :words_to_place, :use_hiragana, :enable_logging, :existing_grid

  def initialize(word_dictionary: nil, words: nil, words_to_place: 10, use_hiragana: true, enable_logging: false, existing_grid: nil)
    @use_hiragana = use_hiragana
    @enable_logging = enable_logging
    @word_dictionary = word_dictionary || Word.all.index_by { |word| word_field(word) }
    @words = words || Word.all.sample(2_000)
    @words_to_place = words_to_place
    @existing_grid = existing_grid

    @grid_initializer = GridInitializerService.new(enable_logging: enable_logging)
    @grid_validation = GridValidationService.new(@word_dictionary, enable_logging: enable_logging)
    @word_placement = WordPlacementService.new(use_hiragana: use_hiragana, enable_logging: enable_logging, grid_validation: @grid_validation)
    @clue_generator = ClueGeneratorService.new(use_hiragana: use_hiragana)
  end

  def run
    grid = @existing_grid ? @existing_grid.map(&:dup) : @grid_initializer.initialize_grid
    placed_words = []
    word_placements = {}

    if @existing_grid
      log "Using existing grid:"
      @grid_initializer.print_grid(grid)
      existing_words = extract_words_from_grid(grid)
      log "Existing words: #{existing_words.inspect}"
      placed_words.concat(existing_words)
      existing_words.each do |word|
        word_placements[word] = find_word_placement(grid, word)
      end
    else
      biggest_word = words.max_by { |word| word_field(word).length }
      log "biggest_word: #{word_field(biggest_word).inspect}"
      start_row, start_col = @word_placement.place_biggest_word(grid, biggest_word)
      placed_words << biggest_word
      word_placements[biggest_word] = { direction: "horizontal", start: [ start_row, start_col ] }
      log grid
    end

    maximum = 1_000
    i = 0

    while placed_words.size <= words_to_place
      word_to_place = @word_placement.find_intersecting_word(words - placed_words, placed_words)
      break unless word_to_place
      log "word_to_place: #{word_field(word_to_place).inspect}"
      break if i > maximum
      i += 1

      placement = @word_placement.place_word(grid, word_to_place, placed_words, words)
      if placement
        log "Word has been placed"
        log grid
        placed_words << word_to_place
        word_placements[word_to_place] = placement
      end
    end

    log "Original grid:"
    @grid_initializer.print_grid(grid)

    cleaned_grid = @grid_initializer.clean_grid(grid)

    log "Cleaned grid:"
    @grid_initializer.print_grid(cleaned_grid)

    clues = @clue_generator.generate_clues(placed_words, word_placements, grid, cleaned_grid)

    {
      placed_words: placed_words,
      grid: cleaned_grid,
      clues: clues
    }
  end

  def check_grid(grid)
    @grid_validation.check_grid(grid)
  end

  def log(message)
    pp message if @enable_logging
  end

  def word_field(word)
    use_hiragana ? word.hiragana : word.romanji
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

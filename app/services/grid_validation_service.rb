class GridValidationService
  def initialize(word_dictionary, enable_logging: false)
    @word_dictionary = word_dictionary
    @enable_logging = enable_logging
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

  def check_words_in_line(line)
    line.split(" ").each do |word_candidate|
      next if word_candidate.length <= 1
      unless @word_dictionary.key?(word_candidate)
        log "Word not found: #{word_candidate.inspect}"
        return false
      end
    end
    true
  end

  def log(message)
    pp message if @enable_logging
  end
end

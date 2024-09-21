class ClueGeneratorService
  def initialize
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
        word: word,
        direction: placement[:direction],
        starting_index: cleaned_start
      }
    end
  end
end

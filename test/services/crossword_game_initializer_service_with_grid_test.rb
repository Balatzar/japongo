require "test_helper"

class CrosswordGameInitializerServiceWithGridTest < ActiveSupport::TestCase
  setup do
    @sample_words = {
      "cat" => Word.new(romanji: "cat"),
      "dog" => Word.new(romanji: "dog"),
      "rat" => Word.new(romanji: "rat")
    }
  end

  test "recognizes existing words in the initial grid" do
    existing_grid = [
      [ "c", "a", "t" ],
      [ " ", " ", " " ],
      [ " ", " ", " " ]
    ]

    service = CrosswordGameInitializerService.new(
      word_dictionary: @sample_words,
      words: [],
      words_to_place: 0,
      use_hiragana: false,
      enable_logging: true,
      existing_grid: existing_grid
    )

    result = service.run

    assert_includes result[:placed_words], @sample_words["cat"], "The word 'cat' should be recognized from the initial grid"
  end

  test "places new words in the existing grid" do
    existing_grid = [
      [ " ", " ", " " ],
      [ "c", "a", "t" ],
      [ " ", " ", " " ]
    ]

    service = CrosswordGameInitializerService.new(
      word_dictionary: @sample_words,
      words: [ @sample_words["rat"] ],
      words_to_place: 1,
      use_hiragana: false,
      enable_logging: true,
      existing_grid: existing_grid
    )

    result = service.run

    assert_includes result[:placed_words], @sample_words["rat"], "The word 'rat' should be placed in the grid"
  end

  test "word created by placement should be returned as clue" do
    sample_words = {
      "nike" => Word.new(romanji: "nike"),
      "ke" => Word.new(romanji: "ke"),
      "fist" => Word.new(romanji: "fist"),
      "sea" => Word.new(romanji: "sea"),
      "se" => Word.new(romanji: "se"),
      "tea" => Word.new(romanji: "tea")
    }

    existing_grid = [
      [ " ", "f", " ", " " ],
      [ "n", "i", "k", "e" ],
      [ " ", "s", "e", " " ],
      [ " ", "t", " ", " " ]
    ]

    service = CrosswordGameInitializerService.new(
      word_dictionary: sample_words,
      words: [ sample_words["tea"] ],
      words_to_place: 6,
      use_hiragana: false,
      enable_logging: true,
      existing_grid: existing_grid
    )

    result = service.run

    # New word sea should be returned as a clue
    assert result[:clues].find { |clue| clue[:word] == sample_words["sea"] }, "The word 'sea' should be returned as a clue"
    # And as a placed word
    assert_includes result[:placed_words], sample_words["sea"], "The word 'sea' should be placed in the grid"
  end

  test "clues should not have negative coordinates" do
    existing_grid = [ [ " ", " ", " ", " ", " ", " ", "ち", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", "ゅ", " ", " " ],
    [ " ", " ", " ", " ", "じ", " ", "う", " ", " " ],
    [ " ", "せ", " ", " ", "ゅ", " ", "か", "た", " " ],
    [ "い", "っ", "し", "ょ", "う", "け", "ん", "め", "い" ],
    [ "わ", "け", " ", " ", "ふ", " ", " ", "す", " " ],
    [ "う", "ん", " ", " ", "く", " ", " ", " ", " " ] ]

    sample_words = {
      "いっしょうけんめい" => Word.new(hiragana: "いっしょうけんめい"),
      "ためす" => Word.new(hiragana: "ためす"),
      "いわう" => Word.new(hiragana: "いわう"),
      "じゅうふく" => Word.new(hiragana: "じゅうふく"),
      "せっけん" => Word.new(hiragana: "せっけん"),
      "ちゅうかん" => Word.new(hiragana: "ちゅうかん"),
      "かた" => Word.new(hiragana: "かた"),
      "わけ" => Word.new(hiragana: "わけ"),
      "うん" => Word.new(hiragana: "うん")
    }

    service = CrosswordGameInitializerService.new(
      word_dictionary: sample_words,
      words: sample_words.values,
      words_to_place: 0,
      use_hiragana: true,
      enable_logging: true,
      existing_grid: existing_grid
    )

    result = service.run

    result[:clues].each do |clue|
      row, col = clue[:starting_index]
      assert row >= 0, "Row should be non-negative"
      assert col >= 0, "Column should be non-negative"
    end
  end
end

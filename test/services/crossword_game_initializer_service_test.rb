require "test_helper"

class CrosswordGameInitializerServiceTest < ActiveSupport::TestCase
  setup do
    @sample_words = {
      "cat" => Word.new(hiragana: "ねこ", romanji: "neko"),
      "dog" => Word.new(hiragana: "いぬ", romanji: "inu"),
      "bird" => Word.new(hiragana: "とり", romanji: "tori"),
      "fish" => Word.new(hiragana: "さかな", romanji: "sakana"),
      "bear" => Word.new(hiragana: "くま", romanji: "kuma")
    }
  end

  test "initialize with hiragana option" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 5, use_hiragana: true)
    assert_equal true, service.use_hiragana
    assert_equal @sample_words, service.word_dictionary
  end

  test "initialize with romanji option" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 5, use_hiragana: false)
    assert_equal false, service.use_hiragana
    assert_equal @sample_words, service.word_dictionary
  end

  test "word_field returns hiragana when use_hiragana is true" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 5, use_hiragana: true)
    assert_equal "ねこ", service.send(:word_field, @sample_words["cat"])
  end

  test "word_field returns romanji when use_hiragana is false" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 5, use_hiragana: false)
    assert_equal "neko", service.send(:word_field, @sample_words["cat"])
  end

  test "run generates clues with hiragana when use_hiragana is true" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 3, use_hiragana: true)
    result = service.run
    assert result[:clues].all? { |clue| clue[:word].match?(/\p{Hiragana}/) }
  end

  test "run generates clues with romanji when use_hiragana is false" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 3, use_hiragana: false)
    result = service.run
    assert result[:clues].all? { |clue| clue[:word].match?(/^[a-z]+$/) }
  end

  test "check_grid with all valid hiragana words" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 5, use_hiragana: true)
    grid = [
      ["ね", "こ", " ", "い", "ぬ"],
      [" ", " ", " ", " ", " "],
      ["と", "り", " ", " ", " "],
      [" ", " ", " ", " ", " "],
      ["さ", "か", "な", " ", " "]
    ]
    assert service.check_grid(grid)
  end

  test "check_grid with all valid romanji words" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 5, use_hiragana: false)
    grid = [
      ["n", "e", "k", "o", " ", "i", "n", "u"],
      [" ", " ", " ", " ", " ", " ", " ", " "],
      ["t", "o", "r", "i", " ", " ", " ", " "],
      [" ", " ", " ", " ", " ", " ", " ", " "],
      ["s", "a", "k", "a", "n", "a", " ", " "]
    ]
    assert service.check_grid(grid)
  end

  test "place_word successfully adds a valid hiragana word" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 5, use_hiragana: true)
    grid = [
      ["と", "り", " ", " ", " "],
      [" ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " "]
    ]
    word = @sample_words["dog"]
    placed_words = [@sample_words["bird"]]
    words = @sample_words.values

    assert service.send(:place_word, grid, word, placed_words, words)
    assert service.check_grid(grid)
  end

  test "place_word successfully adds a valid romanji word" do
    service = CrosswordGameInitializerService.new(word_dictionary: @sample_words, words: @sample_words.values, words_to_place: 5, use_hiragana: false)
    grid = [
      ["t", "o", "r", "i", " "],
      [" ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " "]
    ]
    word = @sample_words["dog"]
    placed_words = [@sample_words["bird"]]
    words = @sample_words.values

    assert service.send(:place_word, grid, word, placed_words, words)
    assert service.check_grid(grid)
  end
end

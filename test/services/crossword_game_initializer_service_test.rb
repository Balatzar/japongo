require "test_helper"

class CrosswordGameInitializerServiceTest < ActiveSupport::TestCase
  setup do
    @sample_words = {
      "cat" => Word.new(romanji: "cat"),
      "dog" => Word.new(romanji: "dog"),
      "bird" => Word.new(romanji: "bird"),
      "fish" => Word.new(romanji: "fish"),
      "bear" => Word.new(romanji: "bear")
    }
    @service = CrosswordGameInitializerService.new(
      word_dictionary: @sample_words,
      words: @sample_words.values,
      words_to_place: 5,
      use_hiragana: false,
      enable_logging: true,
    )
  end

  test "check_grid with all valid words" do
    grid = [
      [ "c", "a", "t", " ", "d", "o", "g" ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ "b", "i", "r", "d", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ "f", "i", "s", "h", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ "b", "e", "a", "r", " ", " ", " " ]
    ]

    assert @service.check_grid(grid)
  end

  test "check_grid with an invalid word" do
    grid = [
      [ "c", "a", "t", " ", "d", "o", "g" ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ "b", "i", "r", "d", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ "f", "i", "s", "h", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ "i", "n", "v", "a", "l", "i", "d" ]
    ]

    assert_not @service.check_grid(grid)
  end

  test "check_grid with vertical words" do
    grid = [
      [ "c", " ", "b", " ", "f" ],
      [ "a", " ", "i", " ", "i" ],
      [ "t", " ", "r", " ", "s" ],
      [ " ", " ", "d", " ", "h" ],
      [ "d", " ", " ", " ", " " ],
      [ "o", " ", " ", " ", " " ],
      [ "g", " ", " ", " ", " " ]
    ]

    assert @service.check_grid(grid)
  end

  test "check_grid with no words" do
    grid = [
      [ " ", " ", " " ],
      [ " ", " ", " " ],
      [ " ", " ", " " ]
    ]

    assert @service.check_grid(grid)
  end

  test "check_grid with partial words" do
    grid = [
      [ "c", "a", " ", "d", "o" ],
      [ " ", " ", " ", " ", " " ],
      [ "b", "i", " ", "f", "i" ],
      [ " ", " ", " ", " ", " " ],
      [ "b", "e", " ", " ", " " ]
    ]

    assert_not @service.check_grid(grid)
  end

  test "check_grid with vertical and horizontal words" do
    grid = [
      [ "c", "a", "t", " ", "d", "o", "g" ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", "b", " ", " ", " " ],
      [ " ", " ", " ", "i", " ", " ", " " ],
      [ " ", " ", " ", "r", " ", " ", " " ],
      [ " ", " ", " ", "d", "o", "g", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ]
    ]

    assert @service.check_grid(grid)
  end

  test "run creates a valid grid" do
    result = @service.run

    assert result[:placed_words].is_a?(Array)
    assert result[:grid].is_a?(Array)
    assert result[:clues].is_a?(Array)
    assert @service.check_grid(result[:grid])
  end
end

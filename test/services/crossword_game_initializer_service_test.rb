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
    CrosswordGameInitializerService.class_variable_set(:@@all_words, @sample_words)
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

    assert CrosswordGameInitializerService.check_grid(grid)
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

    assert_not CrosswordGameInitializerService.check_grid(grid)
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

    assert CrosswordGameInitializerService.check_grid(grid)
  end

  test "check_grid with no words" do
    grid = [
      [ " ", " ", " " ],
      [ " ", " ", " " ],
      [ " ", " ", " " ]
    ]

    assert CrosswordGameInitializerService.check_grid(grid)
  end

  test "check_grid with partial words" do
    grid = [
      [ "c", "a", " ", "d", "o" ],
      [ " ", " ", " ", " ", " " ],
      [ "b", "i", " ", "f", "i" ],
      [ " ", " ", " ", " ", " " ],
      [ "b", "e", " ", " ", " " ]
    ]

    assert_not CrosswordGameInitializerService.check_grid(grid)
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

    assert CrosswordGameInitializerService.check_grid(grid)
  end
end

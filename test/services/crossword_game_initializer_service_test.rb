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

  test "place_word successfully adds a valid word" do
    grid = [
      [ " ", " ", " ", "b", " ", " ", " " ],
      [ " ", " ", " ", "i", " ", " ", " " ],
      [ " ", " ", " ", "r", " ", " ", " " ],
      [ " ", " ", " ", "d", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ]
    ]
    word = @sample_words["dog"]
    placed_words = [ @sample_words["bird"] ]
    words = @sample_words.values

    assert CrosswordGameInitializerService.place_word(grid, word, placed_words, words)
    assert CrosswordGameInitializerService.check_grid(grid)
  end

  test "place_word cannot place an invalid word" do
    grid = [
      [ "c", "a", "t", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ]
    ]
    invalid_word = Word.new(romanji: "invalid")
    placed_words = [ @sample_words["cat"] ]
    words = @sample_words.values + [ invalid_word ]

    assert_not CrosswordGameInitializerService.place_word(grid, invalid_word, placed_words, words)
    assert CrosswordGameInitializerService.check_grid(grid)
  end

  test "add a word to an existing grid" do
    grid = [
      [ "c", "a", "t", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", "b", " ", " ", " " ],
      [ " ", " ", " ", "i", " ", " ", " " ],
      [ " ", " ", " ", "r", " ", " ", " " ],
      [ " ", " ", " ", "d", "o", "g", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ]
    ]
    word = @sample_words["fish"]
    placed_words = [ @sample_words["cat"], @sample_words["bird"], @sample_words["dog"] ]
    assert CrosswordGameInitializerService.place_word(grid, word, placed_words, @sample_words)
    assert_equal [
      [ "c", "a", "t", " ", " ", " ", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ],
      [ " ", " ", " ", "b", " ", " ", " " ],
      [ " ", " ", "f", "i", "s", "h", " " ],
      [ " ", " ", " ", "r", " ", " ", " " ],
      [ " ", " ", " ", "d", "o", "g", " " ],
      [ " ", " ", " ", " ", " ", " ", " " ]
    ], grid
  end

  test "place specific words" do
    grid = [ [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "u", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "t", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", "w", "a", "k", "a", "w", "a", "k", "a", "s", "h", "i", "i", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "u", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "w", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "a", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ],
    [ " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " " ] ]
    word_to_place = Word.new(romanji: "shouhai")
    placed_words = [ Word.new(romanji: "wakawakashii"), Word.new(romanji: "utsuwa") ]
    words = []
    CrosswordGameInitializerService.class_variable_set(:@@all_words, Word.all.index_by(&:romanji))
    assert CrosswordGameInitializerService.place_word(grid, word_to_place, placed_words, words)
  end
end

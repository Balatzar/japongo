class MatchedWordsService
  def self.call
    existing_hiraganas = Hiragana.pluck(:name).to_set

    matched_words = []
    Word.find_each do |word|
      matched_words << word if word.hiragana.chars.all? { |char| existing_hiraganas.include?(char) }
    end

    matched_words
  end
end

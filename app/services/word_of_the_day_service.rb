class WordOfTheDayService
  def self.select_word
    date_seed = Date.current.to_time.to_i
    offset = date_seed % Word.count
    Word.offset(offset).first
  end

  def self.word_of_the_day
    Rails.cache.fetch("word_of_the_day", expires_in: 2.hours) do
      select_word
    end
  end
end

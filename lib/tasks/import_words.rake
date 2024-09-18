require "csv"

namespace :import do
  desc "Import words from JLPT1vocab-Table 1.csv file"
  task words: :environment do
    csv_file = Rails.root.join("db", "data", "JLPT1vocab-Table 1.csv")
    counter = 0

    if File.exist?(csv_file)
      CSV.foreach(csv_file, headers: true, col_sep: ";", quote_char: "\"", liberal_parsing: true) do |row|
        word = Word.find_or_initialize_by(kanji: row["Kanji"])
        word.assign_attributes(
          hiragana: row["Hiragana"],
          english_meaning: row["English Meaning"],
          romanji: row["Romaji"]
        )

        if word.save
          counter += 1
        else
          puts "Error saving word: #{word.errors.full_messages.join(", ")}"
        end
      end

      puts "Imported/Updated #{counter} words"
    else
      puts "Error: CSV file not found at #{csv_file}"
    end
  end
end

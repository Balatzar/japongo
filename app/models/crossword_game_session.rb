# == Schema Information
#
# Table name: crossword_game_sessions
#
#  id         :bigint           not null, primary key
#  clues      :json
#  easy_mode  :boolean          default(FALSE)
#  game_state :json
#  grid       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CrosswordGameSession < ApplicationRecord
  has_and_belongs_to_many :words

  before_create :initialize_game

  private

  def initialize_game
    game_data = CrosswordGameInitializerService.new.run
    self.grid = game_data[:grid]
    self.clues = game_data[:clues]
    self.words = game_data[:placed_words]
    self.game_state = self.grid.map do |row|
      row.map do |cell|
        {
          "answer" => cell,
          "input" => "",
          "hint" => false
        }
      end
    end
  end
end

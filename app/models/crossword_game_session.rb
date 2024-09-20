# == Schema Information
#
# Table name: crossword_game_sessions
#
#  id         :bigint           not null, primary key
#  clues      :json
#  grid       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CrosswordGameSession < ApplicationRecord
  has_and_belongs_to_many :words
end

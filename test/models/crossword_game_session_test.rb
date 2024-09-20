# == Schema Information
#
# Table name: crossword_game_sessions
#
#  id         :bigint           not null, primary key
#  clues      :json
#  easy_mode  :boolean          default(FALSE)
#  grid       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class CrosswordGameSessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

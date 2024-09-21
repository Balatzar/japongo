class CardsController < ApplicationController
  def create
    word = Word.find(params[:word_id])
    card = Card.find_or_initialize_by(front: word.kanji)
    card.back = "#{word.hiragana} (#{word.romanji})\n#{word.english_meaning}"

    if card.save
      notice = "Card created successfully!"
      redirect_back fallback_location: :root, notice: notice
    else
      redirect_back fallback_location: :root, alert: "Failed to create card: #{card.errors.full_messages.join(', ')}"
    end
  end

  def review
    @card = Card.due_for_review.order("RANDOM()").first
    if @card.nil?
      redirect_to root_path, notice: "No cards due for review."
    end
  end

  def answer
    @card = Card.find(params[:card_id])
    quality = params[:quality].to_i

    @card.process_review(quality)

    if @card.save
      redirect_to review_cards_path, notice: "Card reviewed successfully!"
    else
      redirect_to review_cards_path, alert: "Failed to update card review."
    end
  end
end

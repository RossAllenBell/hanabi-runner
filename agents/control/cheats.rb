class Cheats < Agent

  def self.control?
    true
  end

  def produce_move
    card = self.hand.detect do |face_down_card|
      game.playable?(game.dealt_cards.fetch(face_down_card))
    end

    if game.draw_deck.size <= 1
      game.draw_deck += Game.new_deck
    end

    if card.nil?
      return Move::Discard.new(card: self.hand.first)
    else
      return Move::Play.new(card: card)
    end
  end

  def game
    @_game ||= ObjectSpace.each_object(Game).to_a.detect do |game|
      game.players.map(&:agent).include?(self)
    end
  end

end

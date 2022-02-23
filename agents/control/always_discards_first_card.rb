class AlwaysDiscardsFirstCard < Agent

  def self.control?
    true
  end

  def produce_move
    return Move::Discard.new(card: self.hand.first)
  end

end

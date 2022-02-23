class AlwaysPlaysFirstCard < Agent

  def self.control?
    true
  end

  def produce_move
    return Move::Play.new(card: self.hand.first)
  end

end

class AlwaysPlaysFirstCard < Agent

  def produce_move
    return Move::Play.new(card: self.hand.first)
  end

end

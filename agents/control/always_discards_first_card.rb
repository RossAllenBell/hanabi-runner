class AlwaysDiscardsFirstCard < Agent

  def produce_move
    return Move::Discard.new(card: self.hand.first)
  end

end

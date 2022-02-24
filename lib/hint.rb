class Hint

  attr_accessor :card, :suit, :number

  def initialize(card:, suit: nil, number: nil)
    self.card = card
    self.suit = suit
    self.number = number
  end

end

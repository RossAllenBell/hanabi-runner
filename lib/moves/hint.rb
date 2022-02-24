module Move
  class Hint

    attr_accessor :agent, :suit, :number

    def initialize(agent:, suit: nil, number: nil)
      self.agent = agent
      self.suit = suit
      self.number = number
    end

    def to_s
      "{#{self.class.name}: #{self.agent}, suit: #{self.suit}, number: #{self.number}}"
    end

  end
end

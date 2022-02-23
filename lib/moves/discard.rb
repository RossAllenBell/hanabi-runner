module Move
  class Discard

    attr_accessor :card

    def initialize(card:)
      self.card = card
    end

    def to_s
      "{#{self.class.name}: #{card}}"
    end

  end
end

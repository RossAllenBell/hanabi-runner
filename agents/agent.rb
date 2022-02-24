class Agent

  def self.control?
    false
  end

  attr_accessor :player

  def initialize(player:)
    self.player = player
  end

  def hand
    self.player.hand
  end

  def visible_hand(other_agent)
    self.player.visible_hand(other_agent.player)
  end

  def hints
    self.player.hints
  end

  def other_agents
    self.player.other_agents
  end

  def stacks
    self.player.stacks
  end

  def playable?(card)
    self.player.playable?(card)
  end

  def produce_move
    raise 'not implemented'
  end

  def receive_hint!(hint)
    # no op
  end

  def face_down_card_for(visible_card)
    self.player.face_down_card_for(visible_card)
  end

  def out_of_hints?
    return self.player.out_of_hints?
  end

  class Knowledge
    attr_accessor :suits, :numbers

    def initialize(suits:, numbers:)
      self.suits = suits
      self.numbers = numbers
    end

    def empty?
      (Card::Suits::All - self.suits).empty? && (Card::Numbers::All - self.numbers).empty?
    end
  end

  def knowledge_for(card)
    possible_suits = Card::Suits::All.dup
    possible_numbers = Card::Numbers::All.dup

    self.hints.select do |hint|
      hint.card == card
    end.each do |hint|
      if !hint.suit.nil?
        possible_suits = possible_suits.select do |suit|
          suit == hint.suit
        end
      end

      if !hint.number.nil?
        possible_numbers = possible_numbers.select do |number|
          number == hint.number
        end
      end
    end

    return Knowledge.new(suits: possible_suits, numbers: possible_numbers)
  end

end

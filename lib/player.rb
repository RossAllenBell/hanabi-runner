class Player

  attr_accessor :hand, :agent, :hints

  def initialize(game:, agent_class: AlwaysDiscardsFirstCard)
    @game = game
    self.hand = []
    self.hints = []
    self.agent = agent_class.new(player: self)
  end

  def receive_card!(face_down_card)
    raise(face_down_card) unless face_down_card.is_a?(Card::FaceDown)
    raise(self.hand) unless self.hand.size < 4

    self.hand << face_down_card
  end

  def receive_hint!(hint)
    raise(hint) unless self.hand.include?(hint.card)

    self.hints << hint
    self.agent.receive_hint!(hint)
  end

  def produce_move
    self.agent.produce_move
  end

  def other_agents
    start_at = @game.players.index(self)
    agents = []
    while agents.size < @game.players.size - 1
      agents << @game.players[start_at].agent
      start_at = (start_at + 1) % @game.players.size
    end
    agents
  end

  def stacks
    @game.stacks
  end

  def playable?(card)
    @game.playable?(card)
  end

  def visible_hand(other_player)
    return other_player.hand.map do |face_down_card|
      @game.dealt_cards[face_down_card]
    end
  end

  def face_down_card_for(visible_card)
    @game.dealt_cards.to_a.detect do |face_down_card, other_visible_card|
      visible_card == other_visible_card
    end.first
  end

  def out_of_hints?
    return @game.out_of_hints?
  end

end

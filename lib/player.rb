class Player

  attr_accessor :hand, :agent

  def initialize(agent_class: AlwaysDiscardsFirstCard)
    self.hand = []
    self.agent = agent_class.new(player: self)
  end

  def receive_card!(face_down_card)
    raise(face_down_card) unless face_down_card.is_a?(Card::FaceDown)
    raise(self.hand) unless self.hand.size < 4

    self.hand << face_down_card
  end

  def produce_move
    self.agent.produce_move
  end

end

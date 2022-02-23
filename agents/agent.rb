class Agent

  attr_accessor :player

  def initialize(player:)
    self.player = player
  end

  def hand
    self.player.hand
  end

  def produce_move
    raise 'not implemented'
  end

end

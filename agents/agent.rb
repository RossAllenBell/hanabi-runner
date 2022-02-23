class Agent

  attr_accessor :player

  def initialize(player:)
    self.player = player
  end

  def hand
    self.player.hand
  end

end

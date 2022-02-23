class Game

  MAX_HINTS = 8

  CardCounts = {
    Card::Numbers::One => 3,
    Card::Numbers::Two => 2,
    Card::Numbers::Three => 2,
    Card::Numbers::Four => 2,
    Card::Numbers::Five => 1,
  }

  class << self

    def new_deck
      Card::Suits::All.product(Card::Numbers::All).collect do |suit, number|
        (1..CardCounts.fetch(number)).to_a.map do
          Card.new(suit: suit, number: number)
        end
      end.flatten.shuffle
    end

  end

  attr_accessor :start_time, :players, :draw_deck, :discard_deck, :stacks, :hints, :fuses, :dealt_cards, :current_turn

  def initialize(agent_class: AlwaysDiscardsFirstCard)
    self.start_time = Time.now.to_f
    self.players = (0..3).to_a.map do
      Player.new(agent_class: agent_class)
    end
    self.draw_deck = Game.new_deck
    self.discard_deck = []
    self.stacks = Card::Suits::All.map do |suit|
      [suit, []]
    end.to_h
    self.hints = MAX_HINTS
    self.fuses = 3
    self.dealt_cards = {}
    self.current_turn = 0
  end

  def deal!
    raise('deal! called multiple times') unless self.draw_deck.size == 50

    4.times do
      self.players.each do |player|
        deal_card_to_player!(player)
      end
    end

    return self
  end

  def deal_card_to_player!(player)
    card = self.draw_deck.shift
    return if card.nil?
    new_face_down_card = Card::FaceDown.new
    self.dealt_cards[new_face_down_card] = card
    player.receive_card!(new_face_down_card)
  end

  def play!
    while !self.game_over?
      current_player = self.players[self.current_turn]
      handle_move(player: current_player, move: current_player.produce_move)
      self.current_turn = (self.current_turn + 1) % self.players.size
    end

    return self
  end

  def game_over?
    return true if self.fuses <= 0
    return true if self.draw_deck.empty?
    return true if self.score == 25

    return false
  end

  def handle_move(player:, move:)
    if move.is_a?(Move::Discard)
      player.hand.delete(move.card) || raise(move.card)
      self.discard_deck << self.dealt_cards[move.card] || raise(move.card)
      self.hints = [self.hints + 1, MAX_HINTS].min
      deal_card_to_player!(player)
    elsif move.is_a?(Move::Play)
      player.hand.delete(move.card) || raise(move.card)
      played_card = self.dealt_cards[move.card] || raise(move.card)
      if playable?(played_card)
        self.stacks.fetch(played_card.suit) << played_card
      else
        self.discard_deck << played_card
        self.fuses -= 1
      end
      deal_card_to_player!(player)
    else
      raise move.class
    end
  end

  def score
    self.stacks.values.flatten.size
  end

  def playable?(card)
    current_suit_card = self.stacks.fetch(card.suit).last
    return true if current_suit_card.nil? && card.number == 1
    return current_suit_card&.number = card.number - 1
  end

end

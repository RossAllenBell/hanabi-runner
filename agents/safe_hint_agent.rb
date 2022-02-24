class SafeHintAgent < Agent

  def produce_move
    move = check_for_play
    move ||= check_for_playable_hint
    move ||= best_discard

    return move
  end

  def check_for_play
    play = nil
    self.hand.each do |card|
      knowledge = self.knowledge_for(card)

      if knowledge.suits.size == 1 && knowledge.numbers.size == 1
        if playable?(Card.new(suit: knowledge.suits.first, number: knowledge.numbers.first))
          play = Move::Play.new(card: card)
        end
      end

      break if !play.nil?
    end

    return play
  end

  def check_for_playable_hint
    return nil if self.out_of_hints?

    hint = nil
    self.other_agents.each do |other_agent|
      self.visible_hand(other_agent).each do |card|
        if self.playable?(card)
          other_agent_knowledge = other_agent.knowledge_for(self.face_down_card_for(card))
          if other_agent_knowledge.suits.size > 1
            hint = Move::Hint.new(agent: other_agent, suit: card.suit)
          elsif other_agent_knowledge.numbers.size > 1
            hint = Move::Hint.new(agent: other_agent, number: card.number)
          end
        end

        break if !hint.nil?
      end

      break if !hint.nil?
    end

    return hint
  end

  def best_discard
    card_to_discard = self.hand.detect do |face_down_card|
      self.knowledge_for(face_down_card).empty?
    end

    card_to_discard ||= self.hand.sample

    return Move::Discard.new(card: card_to_discard)
  end

end

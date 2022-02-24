describe Agent do

  let(:game) { Game.new.deal! }
  let(:player) { game.players.first }
  let(:agent) { player.agent }
  let(:face_down_card) { agent.hand.first }
  let(:visible_card) { game.dealt_cards[face_down_card] }

  describe :knowledge_for do

    subject { agent.knowledge_for(face_down_card) }

    it 'knows nothing about suits' do
      expect(Card::Suits::All - subject.suits).to be_empty
    end

    it 'knows nothing about numbers' do
      expect(Card::Numbers::All - subject.numbers).to be_empty
    end

    it 'considers the knowledge empty' do
      expect(subject).to be_empty
    end

    context 'a suit hint' do

      before(:each) do
        player.receive_hint!(Hint.new(card: face_down_card, suit: visible_card.suit))
      end

      it 'knows the suit' do
        expect(subject.suits).to eq([visible_card.suit])
      end

      it 'knows nothing about numbers' do
        expect(Card::Numbers::All - subject.numbers).to be_empty
      end

      it 'considers the knowledge non-empty' do
        expect(subject).not_to be_empty
      end

    end

  end

end

describe Game do

  it 'has four players' do
    expect(subject.players.size).to eq(4)
  end

  it 'starts with a deck of 25 cards' do
    expect(subject.draw_deck.size).to eq(50)
  end

  it 'starts with 8 hints'  do
    expect(subject.hints).to eq(8)
  end

  it 'starts with three fuse chances' do
    expect(subject.fuses).to eq(3)
  end

  describe :deal! do

    subject {Game.new.deal!}

    it 'draws from draw deck' do
      expect(subject.draw_deck.size).to eq(34)
    end

  end

  describe :play! do

    context 'always discards agent' do

      subject {Game.new(agent_class: AlwaysDiscardsFirstCard).deal!.play!}

      it 'results in a score of 0' do
        expect(subject.score).to eq(0)
      end

      it 'uses no fuses' do
        expect(subject.fuses).to eq(3)
      end

      it 'uses no hints' do
        expect(subject.hints).to eq(Game::MAX_HINTS)
      end

    end

    context 'always plays agent' do

      subject {Game.new(agent_class: AlwaysPlaysFirstCard).deal!.play!}

      it 'uses up all the fuses' do
        expect(subject.fuses).to eq(0)
      end

      it 'uses no hints' do
        expect(subject.hints).to eq(Game::MAX_HINTS)
      end

    end

    context 'cheating agent' do

      subject {Game.new(agent_class: Cheats).deal!.play!}

      it 'results in a perfect score' do
        expect(subject.score).to eq(25)
      end

      it 'uses no fuses' do
        expect(subject.fuses).to eq(3)
      end

      it 'uses no hints' do
        expect(subject.hints).to eq(Game::MAX_HINTS)
      end

    end

    context 'all agents can play' do
      ObjectSpace.each_object(Class).select { |klass| klass < Agent }.each do |agent_class|
        context "agent: #{agent_class.name}" do
          subject {Game.new(agent_class: agent_class).deal!.play!}

          it 'can run' do
            expect(subject.score).not_to be_nil
            expect(subject.game_over?).to eq(true)
          end
        end
      end
    end

  end

  describe :playable? do

    subject {Game.new}

    it 'can play a 1' do
      expect(subject.playable?(Card.new(suit: 'white', number: 1))).to eq(true)
    end

    it 'can not play a 2' do
      expect(subject.playable?(Card.new(suit: 'white', number: 2))).to eq(false)
    end

    it 'can not play a 3' do
      expect(subject.playable?(Card.new(suit: 'white', number: 3))).to eq(false)
    end

    context 'a 1 has been played' do

      before(:each) do
        subject.stacks.fetch('white') << Card.new(suit: 'white', number: 1)
      end

      it 'can not play a 1' do
        expect(subject.playable?(Card.new(suit: 'white', number: 1))).to eq(false)
      end

      it 'can play a 2' do
        expect(subject.playable?(Card.new(suit: 'white', number: 2))).to eq(true)
      end

      it 'can not play a 3' do
        expect(subject.playable?(Card.new(suit: 'white', number: 3))).to eq(false)
      end

      context 'a 2 has been played' do

        before(:each) do
          subject.stacks.fetch('white') << Card.new(suit: 'white', number: 2)
        end

        it 'can not play a 1' do
          expect(subject.playable?(Card.new(suit: 'white', number: 1))).to eq(false)
        end

        it 'can not play a 2' do
          expect(subject.playable?(Card.new(suit: 'white', number: 2))).to eq(false)
        end

        it 'can not play a 3' do
          expect(subject.playable?(Card.new(suit: 'white', number: 3))).to eq(true)
        end

      end

    end

  end

end

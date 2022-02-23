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

  end

end

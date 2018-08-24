shared_examples_for 'Votable' do
  let(:user) { @user || create(:user) }
  let(:votable_object) { create(object_name, user: user) }

  it 'should create new vote with vote_for' do
    expect { votable_object.vote_for(user) }.to change(Vote, :count).by(1)
  end

  it 'should create new vote with vote_against' do
    expect { votable_object.vote_against(user) }.to change(Vote, :count).by(1)
  end

  it 'should set rating to 1' do
    votable_object.vote_for(user)
    expect(votable_object.rating).to eq 1
  end

  it 'should set rating to -1' do
    votable_object.vote_against(user)
    expect(votable_object.rating).to eq -1
  end

  it "should check does votable_object have vote?" do
    votable_object.vote_for(user)
    expect(votable_object.has_vote?(user)).to eq true
  end

  it 'should get a sum of votes' do
    votable_object.vote_for(user)
    expect(votable_object.rating).to eq 1
  end

  it 'should reset point by removing record for this vote' do
    votable_object.vote_for(user)
    expect { votable_object.reset_vote(user) }.to change(Vote, :count).by(-1)
  end
end

shared_examples_for 'Voted' do
  let(:user) { @user || create(:user) }
  let(:voted_object) { create(object_name, user: user) }
  let(:invalid_user) { create(:user) }
  let(:second_voted_object) { create(object_name, user: invalid_user) }

  describe 'POST #vote_for' do
    sign_in_user

    it "increases rating of other user's voted_object" do
      expect {
        post :vote_for, params: { id: second_voted_object, format: :js }
        }.to change(second_voted_object, :rating).by(1)
    end

    it "does not change rating of current user's voted_object" do
      expect {
        post :vote_for, params: { id: voted_object, format: :js }
        }.to_not change(second_voted_object, :rating)
    end
  end

  describe 'POST #vote_against' do
    sign_in_user

    it "decreases rating of other user's voted_object" do
      expect {
        post :vote_against, params: { id: second_voted_object, format: :js }
        }.to change(second_voted_object, :rating).by(-1)
    end

    it "does not change rating of current user's voted_object" do
      expect {
        post :vote_against, params: { id: voted_object, format: :js }
        }.to_not change(second_voted_object, :rating)
    end
  end

  describe 'POST #reset_vote' do
    sign_in_user
    before {  post :vote_for, params: { id: second_voted_object } }

    it "changes rating of other user's voted_object to 0" do
      expect {
        post :reset_vote, params: { id: second_voted_object, format: :js }
        }.to change(second_voted_object, :rating).by(-1)
    end

    it "does not change rating of current user's voted_object" do
      expect {
        post :reset_vote, params: { id: voted_object, format: :js }
        }.to_not change(second_voted_object, :rating)
    end
  end
end

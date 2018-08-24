require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should have_db_column(:question_id) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_db_column(:best_answer) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:comments).dependent(:destroy) }

  let(:object_name) { :answer }

  it_behaves_like 'Votable'
end

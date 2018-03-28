require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:point) }
  it do
    should validate_inclusion_of(:point).
      in_array([-1, 0, 1])
  end
end

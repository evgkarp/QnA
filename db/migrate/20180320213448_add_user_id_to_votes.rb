class AddUserIdToVotes < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :votes, :user, foreign_key: :user
  end
end

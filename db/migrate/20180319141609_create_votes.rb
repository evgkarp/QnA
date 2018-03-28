class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :point, default: 0
      t.references :votable, polymorphic: true, index: true

      t.timestamps
    end
  end
end

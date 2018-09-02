class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :question, foreign_key: { on_delete: :cascade }, index: true
      t.belongs_to :user, foreign_key: { on_delete: :cascade }, index: true
      t.timestamps
    end

    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end

class AddQuestionIdToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :answers, :question, foreign_key: :question
  end
end

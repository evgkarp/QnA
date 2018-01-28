require 'rails_helper'

feature 'View question', %q{
  In order to know answers to the question
  As an user
  I want to be able to view question with answers
} do
  given!(:answer) { create(:answer) }

  scenario 'User visit to show question page' do
    visit questions_path
    click_on 'MyQuestionTitle'

    expect(current_path).to eq question_path(answer.question)
    expect(page).to have_content 'MyQuestionTitle'
    expect(page).to have_content 'MyQuestionBody'
    expect(page).to have_content 'MyAnswerBody'
  end
end

require_relative '../acceptance_helper'

feature 'View question', %q{
  In order to know answers to the question
  As an user
  I want to be able to see content of the question
} do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:second_answer) { create(:answer, question: question) }

  scenario 'User sees content of question' do
    visit questions_path
    click_on 'MyQuestionTitle'

    expect(page).to have_content 'MyQuestionTitle'
    expect(page).to have_content 'MyQuestionBody'
    expect(page).to have_content answer.body
    expect(page).to have_content second_answer.body
  end
end

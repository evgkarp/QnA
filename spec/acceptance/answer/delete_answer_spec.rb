require 'rails_helper'

feature 'Delete answer', %q{
  In order to be able to delete answer
  As an authenticated user
  I want to be able to delete answer
} do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user tries to delete his answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Answer successfully deleted.'
    expect(page).not_to have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to delete someone else answer' do
    sign_in(user_2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user tries to delete someone else answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content answer.body
    expect(current_path).to eq question_path(question)
  end
end

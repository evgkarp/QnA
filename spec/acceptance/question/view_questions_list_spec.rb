require 'rails_helper'

feature 'View questions list', %q{
  In order to find expected question
  As an user
  I want to be able to see list of questions
} do
  given!(:question) { create(:question) }
  given!(:second_question) { create(:question) }

  scenario 'User sees list of questions' do
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to have_content second_question.title
  end
end

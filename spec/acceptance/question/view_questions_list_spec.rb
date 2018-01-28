require 'rails_helper'

feature 'View questions list', %q{
  In order to find expected question
  As an user
  I want to be able to view questions list
} do
  given!(:questions) { create_list(:question, 2) }

  scenario 'User visit to root page' do
    visit questions_path

    expect(page).to have_content 'MyQuestionTitle'
  end
end

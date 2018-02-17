require_relative '../acceptance_helper'

feature 'Delete question', %q{
  In order to be able to delete question
  As an authenticated user
  I want to be able to delete question
} do
  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Authenticated user deletes his question' do
    sign_in(author)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Question successfully deleted.'
    expect(page).not_to have_content question.title
  end

  scenario 'Authenticated user deletes someone else question' do
    sign_in(non_author)
    visit questions_path

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content question.title
  end

  scenario 'Non-authenticated user deletes someone else question' do
    visit questions_path

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content question.title
  end
end

require_relative '../acceptance_helper'

feature 'Delete files from question', %q{
  In order to be able to delete files from my question
  As an author of question
  I want to be able delete files files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }
  given(:second_user) { create(:user) }

  describe 'Author of question' do
    before do
      sign_in(user)
      visit questions_path
      click_on 'Edit'
    end

    scenario 'deletes file when he edits question', js: true do
      click_on 'Delete attachment'
      click_on question.title

      expect(page).to_not have_content attachment.file.identifier
    end
  end

  scenario "Authenticated user can not see link to delete file from other user's question" do
    sign_in(second_user)
    visit questions_path

    expect(page).to_not have_link 'Edit'
    expect(page).to_not have_link 'Delete'
  end

  scenario "Unauthenticated user can not see link to delete file from other user's question" do
    visit questions_path

    expect(page).to_not have_link 'Edit'
    expect(page).to_not have_link 'Delete'
  end
end

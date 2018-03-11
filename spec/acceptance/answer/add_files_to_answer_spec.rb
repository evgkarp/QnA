require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  describe 'Author of new answer' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Your Answer', with: 'TestContent'
    end

    scenario 'adds one file when he answers the question', js: true do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end

    scenario 'adds two files when he answers the question', js: true do
      click_on 'add attachment'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Post Your Answer'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

  describe 'Author of existing answer' do
    before do
      sign_in(user)
      answer
      visit question_path(question)
      within "#answer-id-#{answer.id}" do
        click_on 'Edit'
      end
    end

    scenario 'adds one file when he edits answer', js: true do
      within "#answer-id-#{answer.id}" do
        click_on 'add attachment'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Save'

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end

    scenario 'adds two files when he edits answer', js: true do
      within "#answer-id-#{answer.id}" do
        click_on 'add attachment'
        click_on 'add attachment'
        inputs = all('input[type="file"]')
        inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
        inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
        click_on 'Save'

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end
  end
end

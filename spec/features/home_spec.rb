require 'rails_helper'

describe "Home" do
  describe 'get /' do
    it 'should be able to create a new match' do
      visit root_path
      expect(page).to have_content('Start New Match')
    end
  end
end

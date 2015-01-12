require 'spec_helper'

describe 'layouts/application' do

  context 'signed-in user' do

    before do
      sign_in FactoryGirl.create(:confirmed_user)
      render
    end

    it "should show title bar" do
      expect(rendered).to have_selector('div#title_bar')
    end

  end

  context 'signed-out user' do
    before do
      render
    end
    it "should not show title bar" do
      expect(rendered).to_not have_selector('div#title_bar')
    end
  end


end
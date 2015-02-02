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

    describe "sidebar" do
      before do
        view.stub(:show_sidebar?).and_return(true)
        render
      end
      specify { expect(rendered).to have_selector('div#sidebar h3', text: I18n.t('fishing_memories.sidebars.filters')) }
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
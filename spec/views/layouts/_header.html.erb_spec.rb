require 'spec_helper'

describe 'layouts/_header' do

  context 'signed-in user' do

    before do
      sign_in FactoryGirl.create(:confirmed_user)
      render
    end

    it "should display logo with memories" do
      expect(rendered).to have_link((Memory.model_name.human count: PLURAL_MANY_COUNT), href: root_path)
    end

    it "should display tackles, ponds links" do
      expect(rendered).to have_link((Tackle.model_name.human count: PLURAL_MANY_COUNT), href: tackles_path)
      expect(rendered).to have_link((Pond.model_name.human count: PLURAL_MANY_COUNT), href: ponds_path)
    end

  end

  context 'signed-out user' do
    before do
      render
    end
    it "should display logo with main title" do
      expect(rendered).to have_link(I18n.t('fishing_memories.title'), href: root_path)
    end

    it "should not display tackles, ponds links" do
      expect(rendered).to_not have_link((Tackle.model_name.human count: PLURAL_MANY_COUNT), href: tackles_path)
      expect(rendered).to_not have_link((Pond.model_name.human count: PLURAL_MANY_COUNT), href: ponds_path)
    end
  end


end
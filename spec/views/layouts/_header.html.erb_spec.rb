require 'spec_helper'

describe 'layouts/_header' do

  context 'signed-in user' do

    before do
      sign_in FactoryGirl.create(:confirmed_user)
      render
    end

    it "should display logo with memories" do
      expect(rendered).to have_link(I18n.t('fishing_memories.title'), href: root_path)
    end

    it "should display tackles, ponds links" do
      expect(rendered).to have_link((Memory.model_name.human count: PLURAL_MANY_COUNT), href: memories_path)
      expect(rendered).to have_link((Tackle.model_name.human count: PLURAL_MANY_COUNT), href: tackles_path)
      expect(rendered).to have_link((TackleSet.model_name.human count: PLURAL_MANY_COUNT), href: tackle_sets_path)
      expect(rendered).to have_link((Pond.model_name.human count: PLURAL_MANY_COUNT), href: ponds_path)
      expect(rendered).to have_link((Place.model_name.human count: PLURAL_MANY_COUNT), href: places_path)
    end

    it "should display categories links" do
      expect(rendered).to have_link((Category.model_name.human count: PLURAL_MANY_COUNT))
      expect(rendered).to have_link((PondCategory.model_name.human count: PLURAL_MANY_COUNT), href: pond_categories_path)
      expect(rendered).to have_link((TackleCategory.model_name.human count: PLURAL_MANY_COUNT), href: tackle_categories_path)
      expect(rendered).to have_link((TackleSetCategory.model_name.human count: PLURAL_MANY_COUNT), href: tackle_set_categories_path)
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
      expect(rendered).to_not have_link((Memory.model_name.human count: PLURAL_MANY_COUNT), href: memories_path)
      expect(rendered).to_not have_link((Tackle.model_name.human count: PLURAL_MANY_COUNT), href: tackles_path)
      expect(rendered).to_not have_link((TackleSet.model_name.human count: PLURAL_MANY_COUNT), href: tackle_sets_path)
      expect(rendered).to_not have_link((Pond.model_name.human count: PLURAL_MANY_COUNT), href: ponds_path)
    end
  end


end
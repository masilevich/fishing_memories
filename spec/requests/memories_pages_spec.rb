require 'spec_helper'
require "user_helper"
require 'active_support/core_ext/string/filters'

describe "MemoriesPages" do
	include_context "login user"

	describe "index" do
		let!(:memories) { FactoryGirl.create_list(:memory, 10, user: user) }
		let!(:lond_desc_memory) { FactoryGirl.create(:memory, user: user, description: 'a'*100) }
		before {visit memories_path}

		it "should have table" do
			expect(page).to have_selector('th', text: Memory.human_attribute_name("occured_at"))
			expect(page).to have_selector('th', text: Memory.human_attribute_name("description"))
		end

		it "should have content and links in table" do
			memories.each do |memory|
				expect(page).to have_selector('td', text: memory.occured_at)
				expect(page).to have_selector('td', text: memory.description.truncate(90))
				expect(page).to have_link(I18n.t('fishing_memories.show'), href: memory_path(memory))
				expect(page).to have_link(I18n.t('fishing_memories.edit'), href: edit_memory_path(memory))
				expect(page).to have_link(I18n.t('fishing_memories.delete'), href: memory_path(memory))
			end
		end

		it "should have truncated description" do
			expect(page).to have_selector('td', text: lond_desc_memory.description.truncate(90))
		end

	end
end
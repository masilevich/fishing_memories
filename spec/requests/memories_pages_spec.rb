require 'spec_helper'
require "user_helper"

describe "MemoriesPages" do
	include_context "login user"

	describe "index" do
		let(:memories) { FactoryGirl.create_list(:memory, 10) }
		before {visit memories_path}

		it "should have table" do
			expect(page).to have_selector('th', text: Memory.human_attribute_name("occured_at"))
			expect(page).to have_selector('th', text: Memory.human_attribute_name("description"))
		end

		specify do
			memories.each do |memory|
				expect(page).to have_selector('td', text: memory.occured_at)
			end
		end

	end

end

require 'spec_helper'
require 'user_helper'
require 'active_support/core_ext/string/filters'

describe "MemoriesPages" do

	it_should_behave_like "resource pages" do
	  let(:resource_class) { Memory }
	end

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

	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: Memory.model_name.human)}
		before {visit new_memory_path}

		describe "with valid information" do
			before {fill_in "memory_occured_at", with: Time.now }
			it "should create a memory" do
				expect { click_button submit }.to change(Memory, :count).by(1)
			end

			describe "success messages" do
				before { click_button submit }
				it { should have_success_message(I18n.t('fishing_memories.model_created', model: Memory.model_name.human)) }
			end
		end
	end

	describe "show" do
		let!(:memory) { FactoryGirl.create(:memory, user: user) }
		before {visit memory_path(memory)}

		describe "panels" do
		  specify do
				expect(page).to have_selector('div.panel h3', text: I18n.t('fishing_memories.details'))
				expect(page).to have_selector('div.panel h3', text: Memory.human_attribute_name("description"))
			end
		end

		describe "tables" do
		  it "should have head" do
				expect(page).to have_selector('th', text: Memory.human_attribute_name("occured_at"))
			end

			it "should have body" do
				expect(page).to have_selector('td', text: memory.occured_at)
				expect(page).to have_selector('tr', text: memory.description.truncate(90))
			end
		end
		
	end


	describe "edit" do
		let!(:memory) { FactoryGirl.create(:memory, user: user) }
		let(:submit) {I18n.t('fishing_memories.update_model', model: Memory.model_name.human)}
		before {visit edit_memory_path(memory)}

		it { should have_field("memory_occured_at", with: memory.occured_at.strftime("%Y-%m-%d")) }
		it { should have_field("memory_description", with: memory.description) }

		describe "with valid information" do
			before do
				@new_occured_at = DateTime.now.to_date
			  fill_in "memory_occured_at", with: @new_occured_at
			  click_button submit
			  memory.reload
			end 
			it "should update a memory" do
				expect(memory.occured_at).to eq @new_occured_at
			end

			
		end
	end
end
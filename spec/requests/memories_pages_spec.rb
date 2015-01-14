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

		describe "select" do
			let!(:ponds) { FactoryGirl.create_list(:pond, 3, user: user) }
			let!(:tackles) { FactoryGirl.create_list(:tackle, 3, user: user) }
			let(:other_user) { FactoryGirl.create(:confirmed_user) }
		  let!(:other_user_tackles) { FactoryGirl.create_list(:tackle, 3, user: other_user) }
		  let!(:other_user_ponds) { FactoryGirl.create_list(:pond, 3, user: other_user) }
		  before {visit new_memory_path}

		  context "tackles" do
		  	it { should have_select('memory[tackle_ids][]', :options => tackles.map { |e| e.name}.sort) }
			end

			context "ponds" do
		  	it { should have_select('memory[pond_ids][]', :options => ponds.map { |e| e.name}.sort) }
			end

		end

		describe "with valid information" do
			let!(:pond) { FactoryGirl.create(:pond, user: user) }
			let!(:tackle) { FactoryGirl.create(:tackle, user: user) }
			before do
				@occured_at = DateTime.now.to_date
				visit new_memory_path
				select tackle.name, :from => "memory[tackle_ids][]"
				select pond.name, :from => "memory[pond_ids][]"
				fill_in "memory_occured_at", with: @occured_at
			end
			it "should create a memory" do
				expect { click_button submit }.to change(Memory, :count).by(1)
			end

			context 'memory' do
				before do
					click_button submit
					@memory = Memory.order("created_at").last
				end
				it "should have selected fields" do
					expect(@memory.occured_at).to eq @occured_at
					expect(@memory.ponds.first).to eq pond
					expect(@memory.tackles.first).to eq tackle
				end
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
		let!(:tackles) {FactoryGirl.create_list(:tackle, 2, user: user)}
		let!(:ponds) {FactoryGirl.create_list(:pond, 2, user: user)}
		let(:submit) {I18n.t('fishing_memories.update_model', model: Memory.model_name.human)}
		before do
			visit edit_memory_path(memory)
			memory.ponds << ponds.first
			memory.tackles << tackles.first
		end

		it { should have_field("memory_occured_at", with: memory.occured_at.strftime("%Y-%m-%d")) }
		it { should have_field("memory_description", with: memory.description) }

		describe "with valid information" do
			before do
				@new_occured_at = DateTime.now.to_date
			  fill_in "memory_occured_at", with: @new_occured_at
			  select tackles.second.name, :from => "memory[tackle_ids][]"
				select ponds.second.name, :from => "memory[pond_ids][]"
			  click_button submit
			  memory.reload
			end 
			it "should update a memory date" do
				expect(memory.occured_at).to eq @new_occured_at
			end

			it "should contain right ponds" do
				expect(memory.ponds).to include(ponds.second)
				expect(memory.ponds).to_not include(ponds.first)
			end

			it "should contain right tackles" do
				expect(memory.tackles).to include(tackles.second)
				expect(memory.tackles).to_not include(tackles.first)
			end
		end

	end
end
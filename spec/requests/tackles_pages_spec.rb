require 'spec_helper'
require 'user_helper'

describe "TacklesPages" do
  include_context "login user"

	describe "index" do
		let!(:tackles) { FactoryGirl.create_list(:tackle, 10, user: user) }
		before {visit tackles_path}

		it "should have table" do
			expect(page).to have_selector('th', text: Tackle.human_attribute_name("name"))
		end

		it "should have content and links in table" do
			tackles.each do |tackle|
				expect(page).to have_selector('td', text: tackle.name)
				expect(page).to have_link(I18n.t('fishing_memories.show'), href: tackle_path(tackle))
				expect(page).to have_link(I18n.t('fishing_memories.edit'), href: edit_tackle_path(tackle))
				expect(page).to have_link(I18n.t('fishing_memories.delete'), href: tackle_path(tackle))
			end
		end

	end

	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: Tackle.model_name.human)}
		before {visit new_tackle_path}

		describe "with valid information" do
			before {fill_in "tackle_name", with: "Рыболовная снасть" }
			it "should create a tackle" do
				expect { click_button submit }.to change(Tackle, :count).by(1)
			end

			describe "success messages" do
				before { click_button submit }
				it { should have_success_message(I18n.t('fishing_memories.model_created', model: Tackle.model_name.human)) }
			end
		end
	end

	describe "show" do
		let!(:tackle) { FactoryGirl.create(:tackle, user: user) }
		before {visit tackle_path(tackle)}

		describe "panels" do
		  specify do
				expect(page).to have_selector('div.panel h3', text: I18n.t('fishing_memories.details'))
			end
		end

		describe "tables" do
		  it "should have head" do
				expect(page).to have_selector('th', text: Tackle.human_attribute_name("name"))
			end

			it "should have body" do
				expect(page).to have_selector('td', text: tackle.name)
			end
		end
		
	end

	describe "edit" do
		let!(:tackle) { FactoryGirl.create(:tackle, user: user) }
		let(:submit) {I18n.t('fishing_memories.update_model', model: Tackle.model_name.human)}
		before {visit edit_tackle_path(tackle)}

		it { should have_field("tackle_name", with: tackle.name) }

		describe "with valid information" do
			before do
				@new_name = "Новое название"
			  fill_in "tackle_name", with: @new_name
			  click_button submit
			  tackle.reload
			end 
			it "should update a tackle" do
				expect(tackle.name).to eq @new_name
			end

			
		end
	end
end

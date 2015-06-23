require 'spec_helper'
require 'user_helper'
require "requests/shared_examples/resource_pages"
require "requests/shared_examples/resource_with_name_pages"
require "requests/shared_examples/categorizable_pages"
require "requests/shared_examples/related_memories"
require "requests/shared_examples/filter"
require "requests/shared_examples/sorted_table"

describe "LuresPages" do
	let(:resource_class) { Lure }

	it_should_behave_like "resource pages" 

	it_should_behave_like "resource with name pages" 

	it_should_behave_like "categorizable pages"

	include_context "login user"

	describe "index" do
		let!(:lures) { FactoryGirl.create_list(:lure_with_brand, 3, user: user) }

		describe "json" do
			before do 
				@expected = lures.sort_by {|u| u.title}.map { |e| {title: e.title, url: lure_path(e)} }.to_json
				get lures_path, format: :json 
			end
			specify { expect(response.body).to eq @expected }
		end

		describe "html" do
			before {visit lures_path}

			it "should have table" do
				expect(page).to have_selector('th', text: Lure.human_attribute_name("brand"))
			end

			it "should have content in table" do
				lures.each do |lure|
					expect(page).to have_link(lure.brand.name, href: brand_path(lure.brand))
				end
			end
		end

	end

	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: Lure.model_name.human)}
		let!(:brands) { FactoryGirl.create_list(:brand, 3, user: user) }

		describe "select" do
			let(:other_user) { FactoryGirl.create(:confirmed_user) }
			let!(:other_user_brands) { FactoryGirl.create_list(:brand, 3, user: other_user) }
			before {visit new_lure_path}

			context "brands" do
				it { should have_select('lure[brand_id]', :options => [""] + brands.map { |e| e.name}.sort) }
			end

		end

		describe "with valid information" do
			before do
				@name = "Polaris 1.8"
				visit new_lure_path
				select brands.first.name, :from => "lure[brand_id]"
				fill_in "lure_name", with: @name
			end
			it "should create a lure" do
				expect { click_button submit }.to change(Lure, :count).by(1)
			end

			context 'lure' do
				before do
					click_button submit
					@lure = Lure.order("created_at").last
				end
				it "should have selected fields" do
					expect(@lure.name).to eq @name
					expect(@lure.brand).to eq brands.first
				end
			end

			describe "success messages" do
				before { click_button submit }
				it { should have_success_message(I18n.t('fishing_memories.model_created', model: Lure.model_name.human)) }
			end
		end
	end

	describe "show" do
		let!(:lure) { FactoryGirl.create(:lure_with_brand, user: user) }
		before {visit lure_path(lure)}

		describe "panels" do
			specify do
				expect(page).to have_selector('div.panel h3', text: I18n.t('fishing_memories.details'))
			end
		end

		describe "tables" do
			it "should have head" do
				expect(page).to have_selector('th', text: Lure.human_attribute_name("brand"))
			end

			it "should have body" do
				expect(page).to have_link(lure.brand.title, href: brand_path(lure.brand))
			end
		end

	end

end

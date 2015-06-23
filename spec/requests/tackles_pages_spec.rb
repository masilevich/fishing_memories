require 'spec_helper'
require 'user_helper'
require "requests/shared_examples/resource_pages"
require "requests/shared_examples/resource_with_name_pages"
require "requests/shared_examples/categorizable_pages"
require "requests/shared_examples/related_memories"

describe "TacklesPages" do

	let(:resource_class) { Tackle }

	it_should_behave_like "resource pages"

	it_should_behave_like "resource with name pages"

	it_should_behave_like "categorizable pages"

	include_context "login user"

	describe "index" do
		let!(:tackles) { FactoryGirl.create_list(:tackle_with_brand, 3, user: user) }

		before {visit tackles_path}

		it "should have table" do
			expect(page).to have_selector('th', text: Tackle.human_attribute_name("brand"))
		end

		it "should have content in table" do
			tackles.each do |tackle|
				expect(page).to have_link(tackle.brand.name, href: brand_path(tackle.brand))
			end
		end

	end

	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: Tackle.model_name.human)}
		let!(:brands) { FactoryGirl.create_list(:brand, 3, user: user) }

		describe "select" do
			let(:other_user) { FactoryGirl.create(:confirmed_user) }
			let!(:other_user_brands) { FactoryGirl.create_list(:brand, 3, user: other_user) }
			before {visit new_tackle_path}

			context "brands" do
				it { should have_select('tackle[brand_id]', :options => [""] + brands.map { |e| e.name}.sort) }
			end

		end

		describe "with valid information" do
			before do
				@name = "Soare S707SULS"
				visit new_tackle_path
				select brands.first.name, :from => "tackle[brand_id]"
				fill_in "tackle_name", with: @name
			end
			it "should create a tackle" do
				expect { click_button submit }.to change(Tackle, :count).by(1)
			end

			context 'tackle' do
				before do
					click_button submit
					@tackle = Tackle.order("created_at").last
				end
				it "should have selected fields" do
					expect(@tackle.name).to eq @name
					expect(@tackle.brand).to eq brands.first
				end
			end

			describe "success messages" do
				before { click_button submit }
				it { should have_success_message(I18n.t('fishing_memories.model_created', model: Tackle.model_name.human)) }
			end
		end
	end

	describe "show" do
		let!(:tackle) { FactoryGirl.create(:tackle_with_brand, user: user) }
		before {visit tackle_path(tackle)}

		describe "panels" do
			specify do
				expect(page).to have_selector('div.panel h3', text: I18n.t('fishing_memories.details'))
			end
		end

		describe "tables" do
			it "should have head" do
				expect(page).to have_selector('th', text: Tackle.human_attribute_name("brand"))
			end

			it "should have body" do
				expect(page).to have_link(tackle.brand.title, href: brand_path(tackle.brand))
			end
		end

		describe "related memories" do
			include_context "login user"
			let!(:tackle_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.today.to_date) }
			let!(:tackle) { FactoryGirl.create(:tackle, user: user, memories: tackle_memories) }
			let!(:in_tackle_tackle_set) { FactoryGirl.create(:tackle_set, user: user, tackles: [tackle] ) }
			let!(:memory_in_tackle_set) { FactoryGirl.create(:memory, user: user, 
				tackle_sets: [in_tackle_tackle_set]) }

			it_should_behave_like "table with related memories" do
				let!(:memories) {tackle.memories_with_tackle_sets_memories}
				let!(:other_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.yesterday.to_date) }
				before {visit tackle_path(tackle)}
			end
		end

	end
end

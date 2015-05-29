require 'spec_helper'
require 'user_helper'
require "requests/shared_examples/resource_pages"
require "requests/shared_examples/resource_with_name_pages"
require "requests/shared_examples/categorizable_pages"
require "requests/shared_examples/related_memories"
require "requests/shared_examples/filter"
require "requests/shared_examples/sorted_table"

describe "PondsPages" do

	let(:resource_class) { Pond }

	it_should_behave_like "resource pages" 

	it_should_behave_like "resource with name pages" 

	it_should_behave_like "categorizable pages"

	include_context "login user"

	describe "show" do
		describe "related memories" do
			
			let!(:pond_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.today.to_date) }
			let!(:pond) { FactoryGirl.create(:pond, user: user, memories: pond_memories) }

			it_should_behave_like "table with related memories" do
				let!(:memories) {pond.memories}
				let!(:other_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.yesterday.to_date) }
				before {visit pond_path(pond)}
			end
		end

		describe "tables" do
			describe "pond places" do
				let!(:pond) { FactoryGirl.create(:pond, user: user) }
			  let!(:pond_places) { FactoryGirl.create_list(:place, 3, user: user, pond: pond) }
			  before {visit pond_path(pond)}

			  it "should have head" do
					expect(page).to have_selector('th', text: Pond.human_attribute_name("places"))
				end

				it "should have body" do
					pond.places.each { |place|  expect(page).to have_link(place.name, href: place_path(place))}
				end
			end
		end
	end

end

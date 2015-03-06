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

	describe "show" do
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

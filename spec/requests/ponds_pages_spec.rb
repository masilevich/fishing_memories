require 'spec_helper'
require 'user_helper'

describe "PondsPages" do
	it_should_behave_like "resource pages" do
		let(:resource_class) { Pond }
	end

	it_should_behave_like "resource with name pages" do
		let(:resource_class) { Pond }
	end

	describe "show" do
		describe "related memories" do
			include_context "login user"
			let!(:pond_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.today.to_date) }
			let!(:pond) { FactoryGirl.create(:pond, user: user, memories: pond_memories) }

			it_should_behave_like "table with related memories" do
				let!(:memories) {pond.memories}
				let!(:other_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.yesterday.to_date) }
				before {visit pond_path(pond)}
			end
		end
	end

end

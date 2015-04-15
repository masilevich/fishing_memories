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

	describe "index" do

		describe "json" do
			include_context "login user"
			let!(:lures) { FactoryGirl.create_list(:lure, 3, user: user) }
			before do 
				@expected = lures.sort_by {|u| u.name}.map { |e| {title: e.title, url: lure_path(e)} }.to_json
				get lures_path, format: :json 
			end
			specify { expect(response.body).to eq @expected }
		end

	end

end

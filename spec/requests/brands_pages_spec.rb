require 'spec_helper'
require 'user_helper'
require "requests/shared_examples/resource_pages"
require "requests/shared_examples/resource_with_name_pages"
require "requests/shared_examples/filter"
require "requests/shared_examples/sorted_table"

describe "BrandsPages" do
	let(:resource_class) { Brand }

	it_should_behave_like "resource pages" 

	it_should_behave_like "resource with name pages" 

end

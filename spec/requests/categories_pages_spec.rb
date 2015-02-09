require 'spec_helper'
require "category_helper"
require 'user_helper'

describe "categories_pages" do
	include_context "category helper"
	include_context "login user"

	CATEGORY_TYPES.each do |type|
		let(:resource_class) { category_class(type) }

		it_should_behave_like "resource pages" 

		it_should_behave_like "resource with name pages" 
	end

end
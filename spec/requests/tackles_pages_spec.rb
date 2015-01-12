require 'spec_helper'
require 'user_helper'

describe "TacklesPages" do
	it_should_behave_like "resource pages" do
	  let(:resource_class) { Tackle }
	end

	it_should_behave_like "resource with name pages" do
	  let(:resource_class) { Tackle }
	end

end

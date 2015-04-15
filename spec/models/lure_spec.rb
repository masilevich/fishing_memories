require 'spec_helper'
require "models/shared_examples/categorizable"
require "models/shared_examples/resource_with_name"

describe Lure do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @lure= user.lures.build(name: "Lure") }

	subject { @lure }

	it_should_behave_like "categorizable"

	describe "#title" do
		its(:title) { should eq @lure.name }
	end
end

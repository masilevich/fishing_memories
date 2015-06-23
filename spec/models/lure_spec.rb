require 'spec_helper'
require "models/shared_examples/categorizable"
require "models/shared_examples/resource_with_name"

describe Lure do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @lure= user.lures.build(name: "Polaris 1.8") }

	subject { @lure }

	it { should respond_to(:brand) }

	it_should_behave_like "categorizable"

	describe "#title" do
		its(:title) { should eq "Polaris 1.8"}

		describe "with brand" do
			let(:brand) { FactoryGirl.create(:brand, user: user, name: "Crazy Fish") }
		  before do
		    @lure.brand = brand
		    @lure.save
		  end
		  its(:title) { should eq "Crazy Fish Polaris 1.8" }
		end
	end
end

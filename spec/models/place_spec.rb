require 'spec_helper'

describe Place do
  it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @place = user.places.build(name: "Place") }

	subject { @place }

	it { should respond_to(:memories) }
	it { should respond_to(:pond) }

	describe "#title" do
		its(:title) { should eq @place.name }
	end
end

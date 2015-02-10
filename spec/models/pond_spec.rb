require 'spec_helper'

describe Pond do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @pond= user.tackles.build(name: "Pond") }

	subject { @pond }

	it { should respond_to(:memories) }

	it_should_behave_like "categorizable"

	describe "#title" do
		its(:title) { should eq @pond.name }
	end
end

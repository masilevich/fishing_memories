require 'spec_helper'
require "models/shared_examples/resource_with_name"

describe Note do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @note= user.notes.build(name: "note") }

	subject { @note }

	it { should respond_to(:text) }

	describe "#title" do
		its(:title) { should eq @note.name }
	end
end
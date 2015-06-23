require 'spec_helper'
require "models/shared_examples/resource_with_name"

describe Brand do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @brand= user.brands.build(name: "Shimano") }

	subject { @brand }

	it { should respond_to(:lures) }
	it { should respond_to(:tackles) }

end
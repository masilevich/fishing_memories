require 'spec_helper'

describe Tackle do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @tackle= user.tackles.build(name: "Fishing tackle") }

	subject { @tackle }

	it { should respond_to(:memories) }

end

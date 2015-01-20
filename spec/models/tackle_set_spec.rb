require 'spec_helper'

describe TackleSet do
  it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @tackle_set= user.tackle_sets.build(name: "Fishing tackle") }

	subject { @tackle_set }

	it { should respond_to(:memories) }
	it { should respond_to(:tackles) }
end

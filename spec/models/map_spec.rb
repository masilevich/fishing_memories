require 'spec_helper'

describe Map do
	
	let(:user) { FactoryGirl.create(:user) }

  before do
    @map = Map.new()
  end

  subject { @map }

  it { should respond_to(:points) }
  it { should respond_to(:user) }

  it { should be_valid }

  describe "#title" do
  	  its(:title) { should eq Map.model_name.human }
	end
end

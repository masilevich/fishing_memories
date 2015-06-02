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
  	describe "for ponds maps" do
  	  let(:pond) {FactoryGirl.create(:pond, user: user, map: @map)}
  	  its(:title) { should eq pond.title }
  	end

  	describe "for places maps" do
  	  let(:place) {FactoryGirl.create(:place, user: user, map: @map)}
  	  its(:title) { should eq place.title }
  	end
		
	end
end

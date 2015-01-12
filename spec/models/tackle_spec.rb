require 'spec_helper'

describe Tackle do
  let(:user) { FactoryGirl.create(:user) }
  before { @tackle = user.tackles.build(name: "Fishing tackle") }

  subject { @tackle }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:title) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @tackle.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @tackle.name = "" }
    it { should_not be_valid }
  end

  describe "#title" do
    its(:title) { should eq @tackle.name }
  end
end

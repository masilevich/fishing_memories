require 'spec_helper'

describe Memory do
  let(:user) { FactoryGirl.create(:user) }
  before { @memory = user.memories.build(description: "Lorem ipsum", occured_at: Time.now) }

  subject { @memory  }

  it { should respond_to(:description) }
  it { should respond_to(:occured_at) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:title) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @memory.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank occured_at" do
    before { @memory.occured_at = "" }
    it { should_not be_valid }
  end

  describe "#title" do
    its(:title) { should eq "#{Memory.model_name.human} #{I18n.t('date.from')} #{@memory.occured_at}" }
  end
end

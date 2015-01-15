shared_examples 'resource with name' do
	let(:user) { FactoryGirl.create(:user) }
  before { @resource= user.send(described_class.model_name.plural).build(name: "Fishing tackle") }

	subject { @resource }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	it { should respond_to(:title) }

	its(:user) { should eq user }

	it { should be_valid }

	describe "when user_id is not present" do
		before { @resource.user_id = nil }
		it { should_not be_valid }
	end

	describe "with blank name" do
		before { @resource.name = "" }
		it { should_not be_valid }
	end

	describe "#title" do
		its(:title) { should eq @resource.name }
	end

end
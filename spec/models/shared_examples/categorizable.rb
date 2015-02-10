shared_examples 'categorizable' do
	it { should respond_to(:category) }
	it { should respond_to(:category_id) }
end
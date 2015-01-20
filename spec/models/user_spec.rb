require 'spec_helper'

describe User do
    
  before do
    @user = User.new(username: "example_user", email: "user@example.com",
     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:memories) }
  it { should respond_to(:tackles) }
  it { should respond_to(:tackle_sets) }

  #it { should respond_to(:role) }

  it { should be_valid }


  describe "validation" do


    describe "when user name is not present" do
      before { @user.username = " " }
      it { should_not be_valid }
    end


    describe "when user name is too long" do
      before { @user.username = "a" * 21 }
      it { should_not be_valid }
    end


    describe "when email is not present" do
      before { @user.email = " " }
      it { should_not be_valid }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
         foo@bar_baz.com foo@bar+baz.com]
         addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).to_not be_valid
        end
      end
    end


    describe "when user name format is invalid" do
      it "should be invalid" do
        usersnames = %w[user@foo,com user_at_foo. 123example
         foo_baz.com foo'bar ex!ample]
         usersnames.each do |invalid_username|
          @user.username= invalid_username
          expect(@user).to_not be_valid
        end
      end
    end


    describe "when email format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    describe "when email address is already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end

    describe "when user name is already taken" do
      before do
        user_with_same_username = @user.dup
        user_with_same_username.save
      end

      it { should_not be_valid }
    end

    describe "when password is not present" do
      before { @user.password = @user.password_confirmation = " " }
      it { should_not be_valid }
    end

    describe "when password doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }
      it { should_not be_valid }
    end

    describe "with a password that's too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end
  end

  describe "memory associations" do

    before { @user.save }
    let!(:older_memory) do
      FactoryGirl.create(:memory, user: @user, occured_at: 1.day.ago)
    end
    let!(:newer_memory) do
      FactoryGirl.create(:memory, user: @user, occured_at: 1.hour.ago)
    end

    it "should have the right memories in the right order" do
      expect(@user.memories.to_a).to eq [newer_memory, older_memory]
    end

    it "should destroy associated memories" do
      memories = @user.memories.to_a
      @user.destroy
      expect(memories).not_to be_empty
      memories.each do |memory|
        expect(Memory.where(id: memory.id)).to be_empty
      end
    end
  end

=begin
  describe "role" do
    describe "admin" do
      before do
        @user.admin!
      end
      specify do
        expect(@user.role).to eq "admin"
        expect(@user.admin?).to be_true
      end
    end
  end
=end

end

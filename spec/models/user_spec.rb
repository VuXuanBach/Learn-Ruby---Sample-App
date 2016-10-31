require 'spec_helper'

RSpec.describe User, type: :model do
  before {@user = User.new(name: 'Foo Bar', email: 'foo@bar.com',
                           password: 'foobar', password_confirmation: 'foobar')}

  subject {@user}

  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should be_valid}

  describe "when name is not presence" do
    before {@user.name = ''}
    it {should_not be_valid}
  end

  describe "when email is not presence" do
    before {@user.email = ''}
    it {should_not be_valid}
  end

  describe "when name is too long" do
    before {@user.name = 'a' * 51}
    it {should_not be_valid}
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      email_addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      email_addresses.each do |invalid_email|
        @user.email = invalid_email
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email is valid" do
    it "should be valid" do
      email_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      email_addresses.each do |valid_email|
        @user.email = valid_email
        expect(@user).to be_valid
      end
    end
  end

  describe "when a user with duplicated email is created" do
    before do
      user_dup = @user.dup
      user_dup.email = @user.email.upcase
      user_dup.save
    end

    it {should_not be_valid}
  end

  describe "when user enters up case email" do
    let(:up_case_email) {'Foo@Bar.CoM'}
    it "should be saved with all lower case" do
      @user.email = up_case_email
      @user.save

      expect(@user.email).to eq up_case_email.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: "", password_confirmation: "")
    end
    it {should_not be_valid}
  end

  describe "when password confirm is mismatch" do
    before {@user.password_confirmation = 'abc'}
    it {should_not be_valid}
  end

  describe "remember token" do
    before {@user.save}

    it { expect(@user.remember_token).not_to be_blank }
  end
end

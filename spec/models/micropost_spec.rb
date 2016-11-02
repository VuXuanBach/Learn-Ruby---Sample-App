require 'spec_helper'
require 'rspec/its'

describe "Micropost" do

  let(:user) {User.create(name: "test", email: "test@ea.com", password: "foobar", password_confirmation: "foobar")}
  before {@micropost = user.microposts.build(content: "Lorem ipsum")}

  subject {@micropost}

  it {should respond_to :content}
  it {should respond_to :user_id}
  it {should respond_to :user}
  its(:user) {should eq user}

  it {should be_valid}

  describe "when user_id is not present" do
    before {@micropost.user_id = nil}
    it {should_not be_valid}
  end

  describe "when content is blank" do
    before {@micropost.content = " "}
    it {should_not be_valid}
  end

  describe "when content is too long" do
    before {@micropost.content = 'a' * 141}
    it {should_not be_valid}
  end

  describe "micropost associations" do
    let(:sub_user) {User.create!(name: "test", email: "test1@ea.com", password: "foobar", password_confirmation: "foobar")}

    let!(:older_micropost) do
      sub_user.microposts.create!(content: "aa", created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      sub_user.microposts.create!(content: "bb", created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(sub_user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy assiciated microposts" do
      microposts = sub_user.microposts.to_a
      sub_user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |mi|
        expect(Micropost.where(id: mi.id)).to be_empty
      end
    end
  end
end

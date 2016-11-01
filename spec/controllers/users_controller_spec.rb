require 'spec_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  # describe "authorisation" do

  #   describe "for non-signed-in user" do
  #     let (:user) {FactoryGirl.create(:user)}

  #     describe "submitting to the update action" do
  #       before {patch user_path(user)}
  #       specify { expect(response).to redirect_to(signin_path) }
  #     end
  #   end
  # end
end

require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #search_result" do
    it "returns http success" do
      get :search_result
      expect(response).to have_http_status(:success)
    end
  end

end

require 'rails_helper'

RSpec.describe "FinancialMovements", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/financial_movements"
      expect(response).to have_http_status(:success)
    end
  end

end

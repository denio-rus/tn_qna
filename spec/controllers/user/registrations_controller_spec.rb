require 'rails_helper'

RSpec.describe User::RegistrationsController, type: :controller do
  describe "PATCH #ask_email_for_oauth" do
    before do 
      @request.env["devise.mapping"] = Devise.mappings[:user] 
    end

    let(:user) { create(:user, :not_confirmed, email: 'no_email_given@site.om' ) }

    it 'assigns the asked user to @user' do 
      patch :ask_email_for_oauth, params: { id: user, user: { email: 'new@mail.com' } }
      expect(assigns(:user)).to eq user
    end

    it "assigns user's email to given in request's params" do 
      patch :ask_email_for_oauth, params: { id: user, user: { email: 'new@mail.com' } }
      expect(assigns(:user)).to eq user
    end

    context "saves user's new email in db" do
      it 'redirect to index' do
        patch :ask_email_for_oauth, params: { id: user, user: { email: 'new@mail.com' } }
        expect(response).to redirect_to root_path
      end
    end

    context "doesn't save user's email in db" do
      it 'renders update view' do
        patch :ask_email_for_oauth, params: { id: user, user: { email: '' } }
        expect(response).to render_template :ask_email_for_oauth
      end
    end
  end
end
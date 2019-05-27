require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }

  describe "DELETE#destroy" do 
    let!(:link_in_answer) { create(:link, :for_answer) }
    let!(:link_in_question) { create(:link, :for_question) }

    context 'An author of answer deletes link' do
      before { login(link_in_answer.linkable.author) }
  
      it 'deletes the attached file' do
        expect { delete :destroy, params: { id: link_in_answer }, format: :js }.to change(Link, :count).by(-1)
      end
  
      it 'renders delete_link view' do
        delete :destroy, params: { id: link_in_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  
    context "User tries to delete link in another user's answer" do
      before { login(user) }
  
      it 'does not delete the link' do
        expect { delete :destroy, params: { id: link_in_answer }, format: :js }.to_not change(Link, :count)
      end
  
      it 'renders delete_link view' do
        delete :destroy, params: { id: link_in_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'An author of the question deletes link' do
      before { login(link_in_question.linkable.author) }

      it 'deletes the attached file' do
        expect { delete :destroy, params: { id: link_in_question }, format: :js }.to change(Link, :count).by(-1)
      end
  
      it 'renders delete_link view' do
        delete :destroy, params: { id: link_in_question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "User tries to delete link in another user's question" do
      before { login(user) }

      it 'does not delete the link' do
        expect { delete :destroy, params: { id: link_in_question }, format: :js }.to_not change(Link, :count)
      end
  
      it 'renders delete_link view' do
        delete :destroy, params: { id: link_in_question }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end

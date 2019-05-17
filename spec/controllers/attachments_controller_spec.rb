require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  describe "DELETE#destroy" do 
    let(:answer) { create(:answer_with_attached_file) }
    let(:question) { create(:question_with_attached_file) }

    context 'An author of answer deletes attached file' do
      before do
        login(answer.author)
        delete :destroy, params: { id: answer.files.first }, format: :js
      end
  
      it 'deletes the attached file' do
        expect(answer.reload.files).to_not be_attached
      end
  
      it 'renders delete_attachment view' do
        expect(response).to render_template :destroy
      end
    end
  
    context "User tries to delete file attached to another user's answer" do
      before do
        login(user)
        delete :destroy, params: { id: answer.files.first }, format: :js
      end
  
      it 'does not delete the attached file' do
        expect(answer.reload.files).to be_attached
      end
  
      it 'renders delete_attachment view' do
        expect(response).to render_template :destroy
      end
    end

    context 'An author of the question deletes attached file' do
      before do
        login(question.author)
        delete :destroy, params: { id: question.files.first }, format: :js
      end

      it 'deletes the attached file' do
        expect(question.reload.files).to_not be_attached
      end

      it 'renders delete_attachment view' do
        expect(response).to render_template :destroy
      end
    end

    context "User tries to delete file attached to another user's question" do
      before do
        login(user)
        delete :destroy, params: { id: question.files.first }, format: :js
      end

      it 'does not delete the attached file' do
        expect(question.reload.files).to be_attached
      end

      it 'renders delete_attachment view' do
        expect(response).to render_template :destroy
      end
    end
  end
end

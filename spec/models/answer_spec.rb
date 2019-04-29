require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presense_of :question_id }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id } 
end
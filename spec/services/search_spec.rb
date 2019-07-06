require 'rails_helper'

RSpec.describe Services::Search do
  subject { Services::Search }
  context 'query_object is :all' do
    it 'calls the method search of ThinkingSphinx' do 
      expect(ThinkingSphinx).to receive(:search).with("NICE",:page=>"1", :per_page=>"20")
      subject.call("NICE", 'all')
    end
  end
  
  context 'query_object is some classname' do 
    it 'calls the method search of the selected class' do 
      %w[Question Answer Comment User].each do |klass|
        expect(klass.constantize).to receive(:search).with("NICE", :page=>"2", :per_page=>"40")
        subject.call("NICE", klass, '2', '40')
      end
    end
  end
end
require 'rails_helper'

RSpec.describe RootController, type: :controller do

  context 'given a request to the server root' do

    before { get :index }

    it 'should return valid response' do
      expect(response).to be_success
    end

    it 'should render root view' do
      expect(response).to render_template('root/index')
    end
  end
end

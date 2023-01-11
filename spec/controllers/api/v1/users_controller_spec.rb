describe Api::V1::UsersController, api: true do
  include Docs::V1::Users::Api
  let(:user) { create(:user) }

  describe 'POST create' do
    include Docs::V1::Sessions::Create
    context 'when success' do
      before do
        post :create, params: { username: FFaker::Lorem.characters(User::MIN_USERNAME_LENGTH.next),
                                password: 'password',
                                password_confirmation: 'password' }
      end

      it 'has status success', :dox do
        expect(response).to have_http_status(:created)
      end

      it 'has return json with tokens', :dox do
        expect(JSON.parse(response.body).keys.sort).to eq %w[access access_expires_at csrf refresh
                                                             refresh_expires_at]
      end
    end
  end
end

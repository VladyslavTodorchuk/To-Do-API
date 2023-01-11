describe Api::V1::SessionsController, api: true do
  include Docs::V1::Sessions::Api
  let(:user) { create(:user) }

  describe 'POST create' do
    include Docs::V1::Sessions::Create
    context 'when success' do
      before do
        post :create, params: { username: user.username, password: user.password }
      end

      it 'has status success', :dox do
        expect(response).to have_http_status(:created)
      end

      it 'has return json with tokens' do
        expect(JSON.parse(response.body).keys).to match_array %w[access access_expires_at csrf refresh
                                                                 refresh_expires_at]
      end
    end

    context 'when unsuccessful' do
      before do
        post :create,
             params: { username: FFaker::Lorem.characters(User::MIN_USERNAME_LENGTH.next), password: 'wrong_password' }
      end

      it 'has status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'has return empty json' do
        expect(JSON.parse(response.body)).to be_empty
      end
    end
  end

  describe 'DELETE destroy' do
    include Docs::V1::Sessions::Destroy
    context 'when success' do
      before do
        payload = { user_id: user.id }
        session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
        tokens = session.login
        request.headers[JWTSessions.access_header] = "Bearer #{tokens[:access]}"
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]
      end

      it 'has status success', :dox do
        delete :destroy
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

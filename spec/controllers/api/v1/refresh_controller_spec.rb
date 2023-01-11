describe Api::V1::RefreshController, api: true do
  include Docs::V1::Refresh::Api
  let(:user) { create(:user) }
  let(:refresh_token) do
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    session.login[:refresh]
  end

  describe 'POST #create' do
    include Docs::V1::Refresh::Create
    context 'when success' do
      before do
        request.headers[JWTSessions.refresh_header] = refresh_token
        post :create
      end

      it 'has status success', :dox do
        expect(response).to have_http_status(:ok)
      end

      it 'has return json with tokens' do
        expect(JSON.parse(response.body).keys.sort).to eq %w[access access_expires_at csrf]
      end
    end
  end
end

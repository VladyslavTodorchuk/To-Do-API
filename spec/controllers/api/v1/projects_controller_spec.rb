describe Api::V1::ProjectsController do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  let(:old_name) { project.name }
  let(:new_name) { FFaker::Lorem.word }

  before do
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    let(:access_token) { "Bearer #{session.login[:access]}" }
  end

  describe 'GET #index' do
    before do
      request.headers[JWTSessions.access_header] = access_token
      get :index
    end

    it do
      expect(response).to have_http_status(:found)
    end

    it do
      expect(JSON.parse(response.body)['data']['projects']).to eq([{ name: project.name,
                                                                     user_id: project.user.id,
                                                                     created_at: project.created_at,
                                                                     updated_at: project.updated_at }])
    end
  end

  describe 'GET #show' do
    before do
      request.headers[JWTSessions.access_header] = access_token
      get :show, params: { id: project.id }
    end

    it do
      expect(response).to have_http_status(:found)
    end

    it do
      expect(JSON.parse(response.body)['data']['project']).to eq({ name: project.name,
                                                                   user_id: project.user.id,
                                                                   created_at: project.created_at,
                                                                   updated_at: project.updated_at })
    end
  end

  describe 'POST #create' do
    before do
      request.headers[JWTSessions.access_header] = access_token
      get :create, params: { name: new_name }
    end

    it do
      expect(response).to have_http_status(:create)
    end

    it do
      expect(JSON.parse(response.body)['data']).to eq({ user_id: project.user.id,
                                                        project_id: project.id })
    end
  end

  describe 'PUT #update' do
    before do
      request.headers[JWTSessions.access_header] = access_token
      get :update, params: { id: project.id, name: new_name }
    end

    it do
      expect(response).to have_http_status(:ok)
    end

    it do
      expect(JSON.parse(response.body)['data']['project']).to eq({ name: new_name,
                                                                   user_id: project.user.id,
                                                                   created_at: project.created_at,
                                                                   updated_at: project.updated_at })
    end
  end

  describe 'DELETE #destroy' do
    before do
      request.headers[JWTSessions.access_header] = access_token
      get :destroy, params: { id: project.id, name: new_name }
    end

    it do
      expect(response).to have_http_status(:ok)
    end
  end
end
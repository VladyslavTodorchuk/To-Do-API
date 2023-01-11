describe Api::V1::TasksController, api: true do
  include Docs::V1::Tasks::Api
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }

  let(:params_task) { attributes_for(:task) }
  let(:new_title) { FFaker::Lorem.word }

  let(:access_token) do
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    "Bearer #{session.login[:access]}"
  end

  describe 'GET #index' do
    include Docs::V1::Tasks::Index
    context 'when success' do
      before do
        task
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status', :dox do
        get :index, params: { project_id: project.id }
        expect(response).to have_http_status(:found)
      end
    end

    context 'when failure' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status' do
        get :index, params: { project_id: rand(0..10) }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #show' do
    include Docs::V1::Tasks::Show
    context 'when success' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status', :dox do
        get :show, params: { id: task.id }
        expect(response).to have_http_status(:found)
      end
    end

    context 'when failure' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status' do
        get :show, params: { id: rand(0...10) }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    include Docs::V1::Tasks::Create
    context 'when success' do
      before do
        request.headers[JWTSessions.access_header] = access_token
        post :create, params: { project_id: project.id, title: new_title, deadline: params_task[:deadline] }
      end

      it 'has status', :dox do
        expect(response).to have_http_status(:created)
      end

      it 'has json', :dox do
        expect(JSON.parse(response.body)['data']['attributes']['title']).to eq(new_title)
      end
    end

    context 'when failure' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status' do
        post :create, params: { project_id: rand(0..10) }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT #update' do
    include Docs::V1::Tasks::Update
    context 'when success' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      context 'when status' do
        let(:params) { { id: task.id, title: params_task[:title] } }

        it 'has status', :dox do
          put :update, params: params
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when update title' do
        let(:params) { { id: task.id, title: params_task[:title] } }

        it 'change title', :dox do
          put :update, params: params
          expect(task.reload.title).to eq(params_task[:title])
        end
      end

      context 'when update position' do
        let(:params) { { id: task.id, position: params_task[:position] + 1 } }

        it 'change position', :dox do
          put :update, params: params
          expect(task.reload.position).to eq(params_task[:position] + 1)
        end
      end

      context 'when completed' do
        let(:params) { { id: task.id, completed: true } }

        it 'change completed', :dox do
          put :update, params: params
          expect(task.reload.completed).to be(true)
        end
      end
    end

    context 'when failure' do
      before do
        task
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status' do
        put :update, params: { id: rand(0..10) }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    include Docs::V1::Tasks::Destroy
    context 'when success' do
      before do
        task
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'destroy task', :dox do
        expect do
          delete :destroy, params: { id: task.id }
        end.to change(Task, :count).from(1).to(0)
      end
    end

    context 'when failure' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status' do
        delete :destroy, params: { id: rand(0..10) }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

describe Api::V1::CommentsController, api: true do
  include Docs::V1::Comments::Api
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:comment) { create(:comment, task: task) }
  let(:comment_attributes) { attributes_for(:comment) }

  let(:access_token) do
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    "Bearer #{session.login[:access]}"
  end

  describe 'GET #index' do
    include Docs::V1::Comments::Index
    context 'when success' do
      before do
        comment
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status', :dox do
        get :index, params: { task_id: task.id }
        expect(response).to have_http_status(:found)
      end
    end

    context 'when failure' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status' do
        get :index, params: { task_id: rand(0..10) }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #show' do
    include Docs::V1::Comments::Show
    context 'when success' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status', :dox do
        get :show, params: { id: comment.id }
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
    include Docs::V1::Comments::Create
    context 'when success' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status', :dox do
        post :create, params: { task_id: task.id, body: comment_attributes[:body] }
        expect(response).to have_http_status(:created)
      end

      context 'when add image' do
        let(:image) { fixture_file_upload('./test_picture.png', 'image/png') }
        let(:params) do
          { task_id: task.id, body: comment_attributes[:body], image: image }
        end

        it 'has image', :dox do
          post :create, params: params
          expect(task.comments.last.image.attached?).to be true
        end
      end
    end

    context 'when failure' do
      before do
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'has status' do
        post :create, params: { task_id: task.id,
                                body: 'a' * Comment::MAX_BODY_LENGTH.next }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    include Docs::V1::Comments::Destroy
    context 'when success' do
      before do
        comment
        request.headers[JWTSessions.access_header] = access_token
      end

      it 'delete comment', :dox do
        expect do
          delete :destroy, params: { id: comment.id }
        end.to change(Comment, :count).from(1).to(0)
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

class V1::Session::Operation::Create < Trailblazer::Operation
  step :find_user,
       Output(Trailblazer::Activity::Left, :failure) => Path(end_id: 'End.failure', end_task: End(:with_failure)) do
    step :not_found
  end
  step :validates_password
  step :generate_tokens

  fail :wrong_password

  def find_user(ctx, params:, **)
    ctx[:user] = User.find_by(username: params[:username])
  end

  def validates_password(_ctx, params:, user:, **)
    user&.valid_password?(params[:password])
  end

  def generate_tokens(ctx, user:, **)
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    ctx[:data] = session.login
  end

  def not_found(ctx, **)
    ctx[:errors] = [I18n.t('errors.not_found')]
  end

  def wrong_password(ctx, **)
    ctx[:errors] = [I18n.t('session.sing_up.message.errors.password')]
  end
end

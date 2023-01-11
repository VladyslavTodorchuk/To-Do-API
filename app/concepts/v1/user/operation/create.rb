class V1::User::Operation::Create < Trailblazer::Operation
  step :validates_user?
  fail :user_exists, fail_fast: true

  step :create_user
  step :save_user
  step :generate_tokens

  fail :add_errors

  def validates_user?(_ctx, params:, **)
    User.find_by(username: params[:username]).nil?
  end

  def user_exists(ctx, **)
    ctx[:errors] = [I18n.t('session.sing_up.message.errors.username')]
  end

  def create_user(ctx, params:, **)
    ctx[:user] = User.new(username: params[:username], password: params[:password])
  end

  def save_user(_ctx, user:, **)
    user.save
  end

  def generate_tokens(ctx, user:, **)
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    ctx[:data] = session.login
  end

  def add_errors(ctx, user:, **)
    ctx[:errors] = user.errors.full_messages
  end
end

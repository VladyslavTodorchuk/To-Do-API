describe User do
  describe 'user' do
    context 'when validations' do
      it do
        is_expected.to allow_values(FFaker::Lorem.word, 'a' * User::MIN_USERNAME_LENGTH.next,
                                    'a' * User::MAX_USERNAME_LENGTH.pred).for(:username)
      end

      it { is_expected.to allow_values('a' * User::MIN_PASSWORD_LENGTH.next).for(:password) }
    end
  end
end

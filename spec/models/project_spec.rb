describe Project do
  describe 'task' do
    context 'when validations' do
      it { is_expected.to allow_values('a' * Project::MAX_TEXT_LENGTH.pred).for(:name) }
    end

    context 'when associations' do
      it { is_expected.to belong_to(:user) }
    end
  end
end

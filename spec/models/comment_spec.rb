describe Comment do
  describe 'comment' do
    context 'when validations' do
      it { is_expected.to allow_values('a' * Comment::MAX_BODY_LENGTH.pred).for(:body) }
    end

    context 'when associations' do
      it { is_expected.to belong_to(:task) }
      it { is_expected.to have_one_attached(:image) }
    end
  end
end

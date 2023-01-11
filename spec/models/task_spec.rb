describe Task do
  describe 'task' do
    context 'when validations' do
      it { is_expected.to allow_values('a' * Task::MAX_TITLE_LENGTH.pred).for(:title) }
      it { is_expected.to allow_values(DateTime.now + rand(0..100)).for(:deadline) }
    end

    context 'when associations' do
      it { is_expected.to belong_to(:project) }
    end
  end
end

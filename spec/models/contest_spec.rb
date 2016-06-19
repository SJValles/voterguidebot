require 'rails_helper'

RSpec.describe Contest, type: :model do
  subject { Fabricate :contest }

  describe '#assign_associates' do
    it 'creates candidates' do
      raw_obj = { candidates: [{ id: 'candidate5', name: 'Frank' }] }
      subject.assign_associates raw_obj
      expect(subject.candidates.first.name).to eq('Frank')
    end
    context 'with a candidate' do
      let(:candidate) { Fabricate :candidate, contest: subject, name: 'Bill' }
      it 'updates candidates' do
        raw_obj = { candidates: [{ id: candidate.id, name: 'Frank' }] }
        subject.assign_associates raw_obj
        expect(subject.candidates.first.name).to eq('Frank')
      end
      it 'deletes candidates' do
        raw_obj = { candidates: [{ id: candidate.id, _destroy: true }] }
        subject.assign_associates raw_obj
        expect(subject.candidates).to be_empty
      end
    end

    it 'creates questions' do
      raw_obj = { questions: [{ id: 'question5', text: 'WHAT ARE THOSE' }] }
      subject.assign_associates raw_obj
      expect(subject.questions.first.text).to eq('WHAT ARE THOSE')
    end
    context 'with a question' do
      let(:question) { Fabricate :question, contest: subject, text: 'WHAT ARE THOSE' }
      it 'updates questions' do
        raw_obj = { questions: [{ id: question.id, text: 'WHAT ARE THOSE' }] }
        subject.assign_associates raw_obj
        expect(subject.questions.first.text).to eq('WHAT ARE THOSE')
      end
      it 'deletes questions' do
        raw_obj = { questions: [{ id: question.id, _destroy: true }] }
        subject.assign_associates raw_obj
        expect(subject.questions).to be_empty
      end
    end

    context 'with endorsers' do
      let(:endorsing_id) { 'candidate2' }
      let(:endorsement) do
        { endorsing_id: endorsing_id,
          endorsing_type: 'candidate',
          endorser: 'Dudes for Dude Stuff' }
      end
      let(:raw_obj) do
        { candidates: [{ id: endorsing_id }],
          endorsements: [endorsement] }
      end

      it 'creates new endorsers' do
        subject.assign_associates raw_obj
        expect(subject.endorsements.first.endorsing).to eq(
          subject.candidates.first)
      end
      context 'with existing candidate' do
        let!(:candidate) { Fabricate :candidate, contest: subject }
        let(:endorsing_id) { candidate.id }
        it 'associates with existing candidate' do
          subject.assign_associates raw_obj
          expect(subject.endorsements.first.endorsing).to eq(candidate)
        end
      end
      context 'with existing candidate' do
        let(:candidate) { Fabricate :candidate, contest: subject }
        let(:endorsing_id) { candidate.id }
        let!(:existing_endorsement) { Fabricate :endorsement, endorsing: candidate, endorser: 'what' }
        it 'updates endorsers' do
          subject.assign_associates raw_obj
          expect(subject.endorsements.first.id).to eq(existing_endorsement.id)
          expect(subject.reload.endorsements.first.endorser).to eq(endorsement[:endorser])
        end
        it 'deletes unused endorsers' do
          subject.assign_associates raw_obj.update(endorsements: [])
          expect(subject.reload.endorsements).to be_empty
        end
      end
    end

    context 'with answers' do
      let(:question_id) { 'question5' }
      let(:candidate_id) { 'candidate2' }
      let(:answer) do
        { question_id: question_id,
          candidate_id: candidate_id,
          text: 'whaaat' }
      end
      let(:raw_obj) do
        { questions: [{ id: question_id}], candidates: [{ id: candidate_id}],
          answers: [answer] }
      end

      it 'creates new answers from new candidates and questions' do
        subject.assign_associates raw_obj
        expect(subject.answers.first.question).to eq(subject.questions.first)
        expect(subject.answers.first.candidate).to eq(subject.candidates.first)
      end

      context 'with an existing question' do
        let(:question) { Fabricate :question, contest: subject }
        let(:question_id) { question.id }
        it 'associates appropriately' do
          subject.assign_associates raw_obj
          expect(subject.answers.first.question).to eq(question)
        end
      end

      context 'with an existing answer' do
        let(:question) { Fabricate :question, contest: subject }
        let(:candidate) { Fabricate :candidate, contest: subject }
        let!(:answer) { Fabricate :answer, text: 'What', question: question,
                                           candidate: candidate }
        let(:raw_obj) do
          { answers: [{ text: 'Different',
                        question_id: question.id,
                        candidate_id: candidate.id }] }
        end
        it 'updates answers' do
          subject.assign_associates raw_obj
          expect(subject.answers.first.id).to eq(answer.id)
          expect(subject.answers.first.text).to eq('Different')
        end
        it 'deletes unused answers' do
          subject.assign_associates({ answers: [{}] })
          expect(subject.reload.answers).to be_empty
        end
      end
    end
  end
end

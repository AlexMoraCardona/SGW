class CandidateVote < ApplicationRecord
     belongs_to :user
     belongs_to :adm_vote
     has_many :votes

     has_one_attached :avatar_candidate

    def self.listac(adm_vote)
        candidatos = CandidateVote.where("adm_vote_id = ?",adm_vote) if adm_vote.present?
        return candidatos
    end

end

class AdmVote < ApplicationRecord
    belongs_to :entity
    has_many :candidate_votes
    has_many :habil_votes
    has_many :votes

    def self.crear_habiles(adm_vote) 
        users = User.where("entity = ? and state = ? and level > ?",adm_vote.entity_id,1,0)
        if users.present?
           users.each do |user|
               habil_vote = HabilVote.new
               habil_vote.vote = 0
               habil_vote.user_id = user.id
               habil_vote.adm_vote_id = adm_vote.id
               habil_vote.save 
           end 
        end    
    end      

end

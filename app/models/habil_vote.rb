class HabilVote < ApplicationRecord
    belongs_to :user
    belongs_to :adm_vote
    has_many :votes

    def self.label_voto(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        end 
    end   
    
    def self.totalhabiles(adm_id)
        habil_votes = HabilVote.where("adm_vote_id = ?",adm_id) if adm_id.present?
        total = 0
        total = habil_votes.count
        return total
    end    
end

class Vote < ApplicationRecord
    belongs_to :user
    belongs_to :adm_vote
    belongs_to :candidate_vote
    belongs_to :habil_vote
    
    def self.label_voto(dato)
        if dato == 0
            @vot = 'NO'
        else    
           @vot = 'SI'
        end   
        return @vot
    end  

    def self.validar_usuario(adm_vote)
        result = 0
        votes = Vote.where("user_id = ? and adm_vote_id = ?",Current.user.id,adm_vote.id)
        cant_votes = 0
        cant_votes = votes.count if votes.present?

        habil = HabilVote.where("user_id = ? and adm_vote_id = ?",Current.user.id, adm_vote.id)
        result = 1 if habil.present?
        result = 2 if cant_votes >= adm_vote.votes_max 
        return result
    end  

    def self.conteo(cand,adm)
        candidato = CandidateVote.find(cand) if cand > 0 && cand.present?
        adm_vote =  AdmVote.find(adm) if adm > 0 && adm.present?
        result = Vote.where("candidate_vote_id = ? and adm_vote_id = ?",candidato.id,adm_vote.id)
        total = 0
        total = result.count if total.present?
        return total
    end

    def self.totalhabiles(adm)
       habil_votes = HabilVote.where("adm_vote_id = ?",adm) 
       cont = 0
       cont = habil_votes.count if habil_votes.present?
       return cont 
    end     

    
    def self.totalvotaron(adm)
       habil_votes = HabilVote.where("adm_vote_id = ? and vote = ?",adm,1) 
       cont = 0
       cont = habil_votes.count if habil_votes.present?
       return cont 
    end     
end

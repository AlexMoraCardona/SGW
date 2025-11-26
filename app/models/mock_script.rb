class MockScript < ApplicationRecord
     belongs_to :entity
     has_rich_text :officer_committee
     has_rich_text :coordinator_drill 
     has_rich_text :alert_activation
     has_rich_text :evacuation_count
     has_rich_text :evacuation_first
     has_rich_text :evacuation_second
     has_rich_text :withdraw_kit
     has_rich_text :withdraw_stretcher
     has_rich_text :withdraw_extinguisher
     has_rich_text :verification
     has_rich_text :return_indication
     has_rich_text :routes_evacuation
     has_rich_text :emergency_exit
     has_rich_text :emergency_resources

    def self.label_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end

end

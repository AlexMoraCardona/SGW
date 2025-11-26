class ProvidesProtectionItem < ApplicationRecord
    belongs_to :provides_protection
    belongs_to :protection_element

    def self.consulta(id)
        provides_protection_items = ProvidesProtectionItem.where("provides_protection_id = ?",id)
        return  provides_protection_items
    end    
end

class Room < ApplicationRecord
    
    validates :name, presence: true

    after_create_commit -> { broadcast_prepend_to "rooms" }    
    after_update_commit -> { broadcast_replace_to "rooms" }
    after_destroy_commit -> { broadcast_remove_to "rooms" }
    #after_create_commit {broadcast_prepend_to "roomis"}



end

class ChangeManagementItem < ApplicationRecord
    belongs_to :change_management
    has_rich_text :activity_plannig
end

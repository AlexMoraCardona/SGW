class ProvidesProtectionItem < ApplicationRecord
    belongs_to :provides_protection
    belongs_to :protection_element
end

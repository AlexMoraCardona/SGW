class Rule < ApplicationRecord
    has_many :evaluations
    has_many :standars
end

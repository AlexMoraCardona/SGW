class Lesson < ApplicationRecord
    belongs_to :entity
    belongs_to :user
    has_rich_text :leccion_que
    has_rich_text :leccion_causa
    has_rich_text :leccion_recome
end

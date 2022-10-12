class Level < ApplicationRecord
    has_many :users, dependent: :restrict_with_exception 
    validates :name, presence: true #Validar la presencia
end

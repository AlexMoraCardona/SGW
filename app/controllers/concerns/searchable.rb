module Searchable
    extend ActiveSupport::Concern
  
    module ClassMethods
  
      def ransackable_attributes(auth_object = nil)
        searchables_methods + _ransackers.keys
      end
  
      # Metodo para obtener las columnas del modelo a buscar
      #
      # Retorno
      #   Array de strings con los nombres de las columnas
      def searchables_methods
        %w{}
      end
  
      def enum_methods
        {}
      end
    end
  end
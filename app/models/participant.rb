class Participant < ApplicationRecord
    belongs_to :user
    belongs_to :evidence

    def self.nombre(dato)
        @nombre = User.find(dato.to_i).name
        return  @nombre 
    end

    def self.documento(dato)
        @documento = User.find(dato.to_i).nro_document

        cadena = @documento.to_s
        n = cadena.length
        i = 0
        separador = 0
        nuevodato = ''
        while i < n
            separador = n - i
            if separador == 4 || separador == 7 || separador == 10 || separador == 13 || separador == 16 
                nuevodato << cadena[i]
                nuevodato << "."
            else 
                nuevodato << cadena[i]
            end 
            i += 1
        end  
        return nuevodato;
    end

end

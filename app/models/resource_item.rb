class ResourceItem < ApplicationRecord
    belongs_to :user

    def label(dato)
        if dato == 0 ; 'NO'
        elsif  dato == 1 ; 'SI'
        end 
    end 

    def labelxs(dato)
        if dato == 0 ; ' '
        elsif  dato == 1 ; 'X'
        end 
    end 

    def labelxn(dato)
        if dato == 0 ; 'X'
        elsif  dato == 1 ; ' '
        end 
    end 

    def miles(valor)
        cadena = valor.to_s
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

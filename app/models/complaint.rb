class Complaint < ApplicationRecord
    belongs_to :entity
    has_many_attached :files_complaint

    def name(user_id)
        name = ''
        usuario = User.find(user_id)
        name = usuario.name
        return name 
    end

    def cargo(user_id)
        cargo = ''
        usuario = User.find(user_id)
        cargo = usuario.activity
        return cargo 
    end

    def email(user_id)
        correo = ''
        usuario = User.find(user_id)
        correo = usuario.email
        return correo
    end

    def usuario(user_id)
        usu = User.find(user_id)
        return usu
    end

    def document(user_id)
        documento = ''
        usuario = User.find(user_id)
        documento = usuario.nro_document

        cadena = documento.to_s
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

    def estado(est)
        if est == 0 ; 'PENDIENTE'
        elsif  est == 1 ; 'RESUELTO'
        elsif  est == 2 ; 'CANCELADO'
        end 
    end      
end

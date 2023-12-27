class AttachmentsController < ApplicationController
   def purge
        attachment = ActiveStorage::Attachment.find(params[:id])
        attachment.purge
        redirect_back fallback_location: root_path, notice: "Archivo borrado correctamente"
   end   
   
   def new
      evaluation_rule_detail.files.attach(params[:files])
   end   
end    
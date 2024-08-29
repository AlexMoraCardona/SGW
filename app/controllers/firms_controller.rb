class FirmsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @firms = Firm.all.decorate
         else
             redirect_to new_session_path, alert: t('common.not_logged_in') 
             session.delete(:user_id)     
         end           
         
    end    

    def new
      @firm = Firm.new  
    end    

    def create
        @firm = Firm.new(firm_params)
        if Current.user.level < 3 && Current.user.level > 0
           if @firm.save then
                @firm.authorize_firm = 0
                @firm.date_authorize_firm = nil 
                @firm.save            
                redirect_to crear_firma_evaluation_rule_detail_path(@firm.evidence_id), notice: t('.created') 
            else
                render :edit, status: :unprocessable_entity
            end
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @firm = Firm.find(params[:id])
    end
    
    def update
        @firm = Firm.find(params[:id])
        if Current.user.level < 3 && Current.user.level > 0
            if @firm.update(firm_params)
                if @firm.authorize_firm.to_i == 0
                    @firm.date_authorize_firm = nil 
                    @firm.save
                else
                    @firm.date_authorize_firm = Time.now if @firm.date_authorize_firm == nil
                    @firm.save
                end    
                redirect_to crear_firma_evaluation_rule_detail_path(@firm.evidence_id), notice: 'Firma actualizada correctamente'
            else
                render :edit, firms: :unprocessable_entity
            end 
        else
            render :edit, firms: :unprocessable_entity
        end 
    end    

    def destroy
        @firm = Firm.find(params[:id])
        evidence = @firm.evidence_id
        @firm.destroy
        redirect_to crear_firma_evaluation_rule_detail_path(evidence), notice: 'Firma borrada correctamente', firm: :see_other
    end    

    private

    def firm_params
        params.require(:firm).permit(:legal_representative, :post, :authorize_firm, 
        :date_authorize_firm, :user_id, :evidence_id )
    end 

end  


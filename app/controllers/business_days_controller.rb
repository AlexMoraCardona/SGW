class BusinessDaysController < ApplicationController
    def index

        if  Current.user && Current.user.level == 1
            @business_days = BusinessDay.where("entity_id = ?",Current.user.entity)
         else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
         end          
         
    end    

    def show
        @business_day = BusinessDay.find(params[:id])
    end

    def new
      @business_day = BusinessDay.new  
    end    

    def create
        @business_day = BusinessDay.new(business_day_params)
        @business_day.day_skilled = @business_day.date_skilled.strftime("%d").to_i
        @business_day.month_skilled = @business_day.date_skilled.strftime("%m").to_i
        @business_day.year_skilled = @business_day.date_skilled.strftime("%Y").to_i

        if @business_day.save then
            redirect_to business_days_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @business_day = BusinessDay.find(params[:id])
    end
    
    def update 
        @business_day = BusinessDay.find(params[:id])
        if @business_day.update(business_day_params)
            redirect_to business_days_path, notice: 'Día actualizado correctamente'
        else
            render :edit, business_days: :unprocessable_entity
        end         
    end    

    def destroy
        @business_day = BusinessDay.find(params[:id])
        @business_day.destroy
        redirect_to business_days_path, notice: 'Día borrado correctamente', business_day: :see_other
    end    

    private

    def business_day_params
        params.require(:business_day).permit(:day_skilled, :date_skilled, :month_skilled, :year_skilled, :entity_id)
    end 

end  

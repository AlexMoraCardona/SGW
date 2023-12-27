class CyclesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @cycles = Cycle.all.decorate
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @cycle = Cycle.new  
    end    

    def create
        @cycle = Cycle.new(cycle_params)

        if @cycle.save then
            redirect_to cycles_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @cycle = Cycle.find(params[:id])
    end
    
    def update
        @cycle = Cycle.find(params[:id])
        if @cycle.update(cycle_params)
            redirect_to cycles_path, notice: 'Ciclo actualizado correctamente'
        else
            render :edit, cycles: :unprocessable_entity
        end         
    end    

    def destroy
        @cycle = Cycle.find(params[:id])
        @cycle.destroy
        redirect_to cycles_path, notice: 'Ciclo borrado correctamente', cycle: :see_other
    end    

    private

    def cycle_params
        params.require(:cycle).permit(:name, :description )
    end 

end  
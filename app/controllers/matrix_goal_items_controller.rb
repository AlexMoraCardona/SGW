class MatrixGoalItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @matrix_goal_items = MatrixGoalItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')  
            session.delete(:user_id)    
        end           
    end  
    
    def new
      @matrix_goal_item = MatrixGoalItem.new  
    end    

    def create
        @matrix_goal_item = MatrixGoalItem.new(matrix_goal_item_params)

        if @matrix_goal_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_goal_item = MatrixGoalItem.find(params[:id])
    end
    
    def update
        @matrix_goal_item = MatrixGoalItem.find(params[:id])
        if @matrix_goal_item.update(matrix_goal_item_params)
            redirect_back fallback_location: root_path, notice: t('.created')
        else
            render :edit, matrix_protections: :unprocessable_entity
        end         
    end    

    def destroy
        @matrix_goal_item = MatrixGoalItem.find(params[:id])
        @matrix_goal_item.destroy
        redirect_back fallback_location: root_path, notice: 'Item borrado correctamente', matrix_goal_item: :see_other
    end    

    private

    def matrix_goal_item_params
        params.require(:matrix_goal_item).permit(:objetives, :meta, :matrix_goal_id, :indicator_id)
    end  

end  
      
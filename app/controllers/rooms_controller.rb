class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
        respond_to do |format|
          format.html { redirect_to rooms_path, notice: "Post Created" }
          format.turbo_stream
        end
    else
      render :new, status: :unprocessable_entity
    end    
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update(room_params)
      redirect_to rooms_path
    else
      render :edit
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_path }
      format.turbo_stream
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

end
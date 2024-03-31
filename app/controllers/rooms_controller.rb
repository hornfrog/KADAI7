class RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  def index
    if params[:area].blank? && params[:keyword].blank?
      @rooms = Room.all
    else
      @rooms = Room.all
    end

     if params[:area].present? && params[:keyword].present?
    @rooms = @rooms.where("name LIKE ? OR description LIKE ? OR address LIKE ?", "%#{params[:area]}%", "%#{params[:keyword]}%", "%#{params[:keyword]}%") 
  elsif params[:keyword].present?
    @rooms = @rooms.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
  elsif params[:area].present?
    @rooms = @rooms.where("address LIKE ?", "%#{params[:area]}%")
  end

    
    render 'search_results' if params[:area].present? || params[:keyword].present? || params[:commit].present?
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      flash[:notice] = "施設が作成されました"
      redirect_to rooms_path
    else
      render "new", status: :unprocessable_entity
    end
  end

  def show
    @room = Room.find(params[:id])
    @reservation = Reservation.new 
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    if @room.update(params.require(:room).permit(:name, :description, :price, :address, :room_image))
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to :show
    else
      render :edit
    end  
  end

  def destroy
  end

  def search
    @rooms = Room.all

    if params[:area].present? || params[:keyword].present?
      @rooms = Room.all
    else
      @rooms = Room.where(user_id: current_user.id).or(Room.where.not(user_id: current_user.id))
    end
    if params[:area].present? || params[:keyword].present?
     @rooms = @rooms.where("name LIKE ? OR description LIKE ? OR  address LIKE ?", "%#{params[:area]}%", "%#{params[:area]}%", "%#{params[:keyword]}%") 
    end 

    render 'search_results'
  end

  def search_by_area
    area = params[:area]
    @rooms = Room.where("address LIKE ?", "%#{area}%")
    render 'search_results'
  end
end

private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :room_image)
  end

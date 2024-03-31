class ReservationsController < ApplicationController 
    before_action :set_room, only: [:create] 
    before_action :set_reservation, only: [:confirm]
  def index
    @reservations = Reservation.all
    @reservations = current_user.reservations.includes(:room)
  end

  def new
    @reservation = current_user.reservations.build
  end
 
  def create
    if params[:commit] == "キャンセル"  
        redirect_to root_path
        return  
      end

    @reservation = @room.reservations.build(reservation_params)
    @reservation.user = current_user
    @reservation.total_amount = calculate_total_price(@reservation)
    if @reservation.save
        redirect_to confirm_reservation_path(@reservation)
    else
        render 'rooms/show'
    end    
  end 

  def show
    @reservation = Reservation.find(params[:id])
  end  

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    flash[:notice] = "予約がキャンセルされました"
    redirect_to reservations_path
  end
  
  def confirm
    @reservation = Reservation.find(params[:id])
  end

  def confirm_reservation
    puts "confirm_reservation action called" 
    @reservation = Reservation.find(params[:id])
    if @reservation.update(confirmed: true)
      flash[:notice] = "予約が確定されました"
      redirect_to reservations_path
    else
      flash[:alert] = "予約の確定に失敗しました"
      render 'confirm'
    end
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    if @reservation.destroy
      flash[:notice] = "予約がキャンセルされました"
    else
      flash[:alert] = "予約のキャンセルに失敗しました"
    end
    redirect_to reservations_path
  end

  private
  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:check_in_date, :check_out_date, :num_of_guests)
  end

  def calculate_total_price(reservation)
    (reservation.check_out_date - reservation.check_in_date).to_i * reservation.room.price * reservation.num_of_guests
  end
end

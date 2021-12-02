class AppointmentsController < ApplicationController
  before_action :set_professional
  before_action :set_appointment, only: %i[ show edit update destroy ]

  # GET /appointments or /appointments.json
  def index
    if session[:user_id] #means the user is logged in
      @appointments = @professional.appointments.order('date DESC')
    else
      redirect_to login_path
    end
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    if session[:user_id].nil?
      redirect_to login_path
    end
  end

  # GET /appointments/new
  def new
    if session[:user_id].nil?
      redirect_to login_path
    end
    @appointment = @professional.appointments.new
  end

  # GET /appointments/1/edit
  def edit
    if session[:user_id].nil?
      redirect_to login_path
    end
    if current_user.role.name == "Consulta"
      redirect_to root_path
    end
  end

  # POST /appointments or /appointments.json
  def create
    if session[:user_id].nil?
      redirect_to login_path
    end
    @appointment = @professional.appointments.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: [@professional, @appointment] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    if session[:user_id].nil?
      redirect_to login_path
    end
    if current_user.role.name == "Consulta"
      redirect_to root_path
    end
      respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: [@professional, @appointment] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    if session[:user_id].nil?
      redirect_to login_path
    end
    if current_user.role.name == "Consulta"
      redirect_to root_path
    end
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to professional_appointments_url, notice: "Se ha cancelado el turno." }
      format.json { head :no_content }
    end
  end

  private
    def set_professional
      @professional = Professional.find(params[:professional_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = @professional.appointments.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:first_name, :last_name, :phone, :note, :date, :professional_id)
    end
end

class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[ show edit update destroy ]

  # GET /professionals or /professionals.json
  def index
    redirect_if_not_logged
    @professionals = Professional.all
  end

  # GET /professionals/1 or /professionals/1.json
  def show
    redirect_if_not_logged
  end

  # GET /professionals/new
  def new
    redirect_if_not_logged
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
    redirect_if_not_logged_or_not_admin
  end

  # POST /professionals or /professionals.json
  def create
    redirect_if_not_logged
    @professional = Professional.new(professional_params)

    respond_to do |format|
      if @professional.save
        format.html { redirect_to @professional, notice: "Professional was successfully created." }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professionals/1 or /professionals/1.json
  def update
    redirect_if_not_logged_or_not_admin
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to @professional, notice: "Professional was successfully updated." }
        format.json { render :show, status: :ok, location: @professional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professionals/1 or /professionals/1.json
  def destroy
    redirect_if_not_logged_or_not_admin
    respond_to do |format|
      format.html { redirect_to professionals_url, notice: @professional.destroy ? "Se ha despedido al profesional." :  "No se puede borrar al profesional por que tiene turnos pendientes." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def professional_params
      params.require(:professional).permit(:full_name)
    end

    def redirect_if_not_logged
      if session[:user_id].nil?
        redirect_to login_path
      end
    end

    def redirect_if_not_logged_or_not_admin
      if session[:user_id].nil?
        redirect_to login_path
      elsif current_user.role.name != "Administracion"
        redirect_to root_path
      end
    end
end

class ExportController < ApplicationController
    before_action :set_professional, only: %i[ export_professional ]
    def export_professional
        if params.include?(:export)
            date = params[:export][:date].to_date
            week = params[:export][:week].to_i
            timewithzone = Time.zone.local(date.year, date.month, date.day) #Para la BD
            #Acá arranca la query time
            if week == 0
                appointments = Appointment.where("professional_id = ?", @professional).where("date BETWEEN ? AND ?", timewithzone.beginning_of_day, timewithzone.end_of_day).all.order('date ASC')
            else
                seventh_day = timewithzone + 6.days
                appointments = Appointment.where("professional_id = ?", @professional).where("date BETWEEN ? AND ?", timewithzone.beginning_of_day, seventh_day.end_of_day).all.order('date ASC')
            end

            appointments.each do |app|
                puts app.first_name
                puts app.date
            end
            redirect_to root_path
        else
            render 'professional_only'   
        end
    end

    def export_all
        if params.include?(:export)
            date = params[:export][:date].to_date
            week = params[:export][:week].to_i
            timewithzone = Time.zone.local(date.year, date.month, date.day) #Para la BD
            #Acá arranca la query time
            if week == 0
                appointments = Appointment.where("date BETWEEN ? AND ?", timewithzone.beginning_of_day, timewithzone.end_of_day).all.order('date ASC')
            else
                seventh_day = timewithzone + 6.days
                appointments = Appointment.where("date BETWEEN ? AND ?", timewithzone.beginning_of_day, seventh_day.end_of_day).all.order('date ASC')
            end

            appointments.each do |app|
                puts app.first_name
                puts app.date
            end
            redirect_to root_path
        else
            render 'all'   
        end
    end
    
    private
        def set_professional
            @professional = Professional.find(params[:professional_id])
        end
end
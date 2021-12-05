class ExportController < ApplicationController
    before_action :set_professional, only: %i[ export_professional ]

    def export_professional
        if params.include?(:export) && !params[:export][:date].blank?
            date = params[:export][:date].to_date
            week = params[:export][:week].to_i
            timewithzone = Time.zone.local(date.year, date.month, date.day) #Para la BD

            if week == 0
                appointments = Appointment.where("professional_id = ?", @professional).where("date BETWEEN ? AND ?", timewithzone.beginning_of_day, timewithzone.end_of_day).all.order('date ASC')
                range = AppointmentsUtils.date_range_to_hash(timewithzone)
            else
                seventh_day = timewithzone + 6.days
                appointments = Appointment.where("professional_id = ?", @professional).where("date BETWEEN ? AND ?", timewithzone.beginning_of_day, seventh_day.end_of_day).all.order('date ASC')
                range = AppointmentsUtils.date_range_to_hash(timewithzone, true)
            end

            AppointmentsUtils.get_appointments_associated_with_days(range, appointments)
            data_to_table = AppointmentsUtils.create_appointments_day_array(range)
            file_path = TableCreator.export_template_result(data_to_table, TimeRange.get_time_ranges)
            
            #redirect_to root_path
            #Descarga del archivo
            download(file_path)
        else
            render 'professional_only'   
        end
    end

    def export_all
        if params.include?(:export) && !params[:export][:date].blank?
            date = params[:export][:date].to_date
            week = params[:export][:week].to_i
            timewithzone = Time.zone.local(date.year, date.month, date.day) #Para la BD
        
            if week == 0
                appointments = Appointment.where("date BETWEEN ? AND ?", timewithzone.beginning_of_day, timewithzone.end_of_day).all.order('date ASC')
                range = AppointmentsUtils.date_range_to_hash(timewithzone)
            else
                seventh_day = timewithzone + 6.days
                appointments = Appointment.where("date BETWEEN ? AND ?", timewithzone.beginning_of_day, seventh_day.end_of_day).all.order('date ASC')
                range = AppointmentsUtils.date_range_to_hash(timewithzone, true)
            end

            AppointmentsUtils.get_appointments_associated_with_days(range, appointments)
            data_to_table = AppointmentsUtils.create_appointments_day_array(range) 
            file_path = TableCreator.export_template_result(data_to_table, TimeRange.get_time_ranges)

            #redirect_to root_path
            #Descarga del archivo
            download(file_path)
        else
            render 'all'   
        end
    end

    def download(path)
        send_file(path, :type => 'application/html', :disposition => 'attachment')
    end
    
    private
        def set_professional
            @professional = Professional.find(params[:professional_id])
        end

end
module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
            abort("Algun parámetro de los recibidos tiene un formato erróneo") unless !Polycon::Utils.check_if_any_string_is_empty(name, surname, phone)
            #Chequear si existe directorio .polycon, si no existe se crea, sino no se hace nada.
            Polycon::Utils.create_polycon_root unless Polycon::Utils.polycon_root_exists?

            #Chequear si existe el profesional, si no existe se tira error
            abort("Profesional inexistente, capaz lo escribió mal") unless Polycon::ProfessionalUtils.professional_folder_exists?(professional)

            #Se busca que no exista un archivo con misma fecha y hora
            abort("Disculpe, esa fecha/hora ya está ocupada") unless !Polycon::AppointmentUtils.appointment_file_exists?(
              Polycon::ProfessionalUtils.path_professional_folder(professional),
              Polycon::Utils.convert_to_file_convention_from_string(date)  
            )
            #Se crea un objeto appointment
            new_appointment = Polycon::Models::Appointment.new(Polycon::Utils.format_string_to_date(date), Polycon::ProfessionalUtils.beautify_professional_name(professional), name, surname, phone, notes)
            
            #Se crea y llena un archivo de texto plano con extensión .paf en la carpeta del profesional con nombre igual al string de la fecha.
            Polycon::AppointmentUtils.create_appointment_file(
                                                              Polycon::ProfessionalUtils.path_professional_folder(professional) , 
                                                              Polycon::Utils.convert_to_file_convention(new_appointment.date_as_string) ,
                                                              new_appointment
                                                            )
            warn "CREADO"
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          #Chequear que exista la carpeta polycon en el home del usuario. Si no existe se devuelve un abort y no se sigue la ejecución.
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Si existe, se busca carpeta del profesional en Dir.home + "/" + ".polycon", Si no existe el profesional, se devuelve un abort.
          abort("El profesional ingresado no existe en nuestro sistema, quizás lo escribiste mal") unless Polycon::ProfessionalUtils.professional_folder_exists?(professional)
          #Si existe, se busca dentro de la carpeta un archivo con el nombre date.paf
          abort("No existe un turno para esa fecha y hora con dicho profesional.") unless Polycon::AppointmentUtils.appointment_file_exists?(
            Polycon::ProfessionalUtils.path_professional_folder(professional) , 
            Polycon::Utils.convert_to_file_convention_from_string(date)
          )

          #Si se encuentra, se deberia volcar la información del archivo en un objeto appointment y usar el to_s
          Polycon::AppointmentUtils.show_appointment_data(
            Polycon::ProfessionalUtils.path_professional_folder(professional),
            Polycon::Utils.convert_to_file_convention_from_string(date),
            Polycon::ProfessionalUtils.beautify_professional_name(professional),
            Polycon::Utils.format_string_to_date(date)
          )
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          #Chequear que exista la carpeta polycon en el home del usuario. Si no existe se devuelve un abort y no se sigue la ejecución.
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Buscar carpeta del profesional en Dir.home + "/" + ".polycon". Si no existe el profesional se devuelve un abort.
          abort("El profesional ingresado no existe en nuestro sistema, quizás lo escribiste mal") unless Polycon::ProfessionalUtils.professional_folder_exists?(professional)
          #Buscar turno en la carpeta, si no existe el turno se aborta.
          abort("El turno ingresado no existe, capaz lo escribiste mal") unless Polycon::AppointmentUtils.appointment_file_exists?(
            Polycon::ProfessionalUtils.path_professional_folder(professional) , 
            Polycon::Utils.convert_to_file_convention_from_string(date)
          )
          #Si existe el turno, se procede a borrar el archivo en el folder específico. Seria algo como Dir.home + "/" + ".polycon" + "/" + "profesional" + "/" + "archivo.paf"
          Polycon::AppointmentUtils.cancel_appointment(
            Polycon::ProfessionalUtils.path_professional_folder(professional),
            Polycon::Utils.convert_to_file_convention_from_string(date)
          )
          warn "Turno cancelado exitosamente"
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)          
          #Chequear que exista la carpeta polycon en el home del usuario. Si no existe se devuelve un abort y no se sigue la ejecución.
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?

          #Buscar carpeta del profesional en Dir.home + "/" + ".polycon". Si no existe el profesional se devuelve un abort.
          abort("El profesional ingresado no existe en nuestro sistema, quizás lo escribiste mal") unless Polycon::ProfessionalUtils.professional_folder_exists?(professional)

          #Borrar tutti.
          Polycon::AppointmentUtils.cancel_all_appointments_from_professional_with_folder(
            Polycon::ProfessionalUtils.path_professional_folder(professional)
          )
          warn "Turnos cancelados"
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:, date: nil) #Most likely que acá no estaría viendo el parámetro date
          #Chequear primero el .polycon folder
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Verificar la existencia del profesional
          abort("El profesional ingresado no existe en nuestro sistema, quizás lo escribiste mal") unless Polycon::ProfessionalUtils.professional_folder_exists?(professional)
          Polycon::ProfessionalUtils.list_all_professional_appointments(professional, date)
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          #warn "TODO: Implementar cambio de fecha de turno con fecha '#{old_date}' para que pase a ser '#{new_date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          #Chequeo carpeta root, si no existe, abort.
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Chequeo carpeta del profesional
          abort("El profesional ingresado no existe en nuestro sistema, quizás lo escribiste mal") unless Polycon::ProfessionalUtils.professional_folder_exists?(professional)
          #Chequeo existencia del archivo viejo
          abort("El turno ingresado no existe, capaz lo escribiste mal") unless Polycon::AppointmentUtils.appointment_file_exists?(
            Polycon::ProfessionalUtils.path_professional_folder(professional) , 
            Polycon::Utils.convert_to_file_convention_from_string(old_date)
          )
          #Chequeo que la nueva fecha no se superponga con un turno ya existente.
          abort("Disculpe, esa fecha/hora ya está ocupada") unless !Polycon::AppointmentUtils.appointment_file_exists?(
            Polycon::ProfessionalUtils.path_professional_folder(professional),
            Polycon::Utils.convert_to_file_convention_from_string(new_date)  
          )
          #Rename del archivo viejo
          Polycon::AppointmentUtils.reschedule(
            Polycon::ProfessionalUtils.path_professional_folder(professional),
            Polycon::Utils.convert_to_file_convention_from_string(old_date),
            Polycon::Utils.convert_to_file_convention_from_string(new_date)
          )
          warn("Turno reprogramado exitosamente")
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          #Chequear carpeta root, si no existe -> abort.
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Chequear carpeta profesional, si no existe -> abort.
          abort("El profesional ingresado no existe en nuestro sistema, quizás lo escribiste mal") unless Polycon::ProfessionalUtils.professional_folder_exists?(professional)
          #Comprobar existencia del archivo, si no existe -> abort.
          abort("El turno ingresado no existe, capaz lo escribiste mal") unless Polycon::AppointmentUtils.appointment_file_exists?(
            Polycon::ProfessionalUtils.path_professional_folder(professional) , 
            Polycon::Utils.convert_to_file_convention_from_string(date)
          )
          #Chequea que se recibieron datos
          abort("No se han recibido datos nuevos para editar") unless !options.empty?
          #Cambiar datos específicos del archivo.
          Polycon::AppointmentUtils.edit_appointment(
            Polycon::ProfessionalUtils.path_professional_folder(professional), 
            Polycon::Utils.convert_to_file_convention_from_string(date),
            Polycon::Utils.format_string_to_date(date),
            Polycon::ProfessionalUtils.beautify_professional_name(professional),
            options
          )
        end
      end

      class ListByDay < Dry::CLI::Command
        desc 'List all appointments by day using enriched text'

        argument :date, required: true, desc: 'Date to search'
        option :professional, required: false, desc: 'Full name of the professional'


        example [
          '"2021-09-16" #List all appointments from all professionals in a specified date.',
          '"2021-09-16" --professional="Alma Estevez" #List all appointments from Alma Estevez in the specified date.',
        ]
        def call(date:, professional: nil)
          #Chequear carpeta root, si no existe -> abort.
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Chequea que la carpeta de reportes exista, si no existe se crea.
          Polycon::Utils.create_reports_folder unless Polycon::Utils.reports_folder_exist?
          #Toma en cuenta si hay profesional especificado o no.
          if professional.nil?
            appointments = Polycon::AppointmentUtils.get_appointments_by_date_range(Polycon::Utils.date_range_to_hash(date))
          else
            appointments = Polycon::AppointmentUtils.get_appointments_by_date_range_from_professional(professional, Polycon::Utils.date_range_to_hash(date))
          end

          #Creación del HTML.
          #Generado en .polycon/reports/YYYY-MM-DD_HH:M.html
          Polycon::TableUtils.export_template_result(
            Polycon::AppointmentUtils.create_appointments_day_array(
              appointments
            ),
            Polycon::Models::TimeRange.get_time_ranges(8,20,30)
          )
        end
      end

      class ListByWeek < Dry::CLI::Command
        desc 'List all appointments by a specified week using enriched text'

        argument :date, required: true, desc: 'Beginning date'
        option :professional, required: false, desc: 'Full name of the professional'


        example [
          '"2021-09-16" #List all appointments from all professionals in a specified week starting from the given date.',
          '"2021-09-16" --professional="Alma Estevez" #List all appointments from Alma Estevez in the specified week starting from the given date.',
        ]
        def call(date:, professional: nil)
          #Chequear carpeta root, si no existe -> abort.
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Chequea que la carpeta de reportes exista, si no existe se crea.
          Polycon::Utils.create_reports_folder unless Polycon::Utils.reports_folder_exist?
          #Toma en cuenta si hay profesional especificado o no.
          if professional.nil?
            appointments = Polycon::AppointmentUtils.get_appointments_by_date_range(Polycon::Utils.date_range_to_hash(date, true))
          else
            appointments = Polycon::AppointmentUtils.get_appointments_by_date_range_from_professional(professional, Polycon::Utils.date_range_to_hash(date, true))
          end

          #Creación del HTML.
          #Generado en .polycon/reports/YYYY-MM-DD_HH:M.html
          Polycon::TableUtils.export_template_result(
            Polycon::AppointmentUtils.create_appointments_day_array(
              appointments
            ),
            Polycon::Models::TimeRange.get_time_ranges(8,20,30)
          )
        end
      end
    end
  end
end

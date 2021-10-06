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
          #puts Polycon::Utils.format_string_to_date(date)
          #warn "TODO: Implementar creación de un turno con fecha '#{date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          
          #Chequear si existe directorio .polycon, si no existe se crea, sino no se hace nada.
          Polycon::Utils.create_polycon_root unless Polycon::Utils.polycon_root_exists?
          
          #Buscar carpeta del profesional, la idea es encontrar strings parecidos perhaps. Si no se encuentra se crea
          Polycon::ProfessionalUtils.create_professional_folder(professional) unless Polycon::ProfessionalUtils.professional_folder_exists?(professional)
          
          #Se crea un objeto appointment
          new_appointment = Polycon::Models::Appointment.new(Polycon::Utils.format_string_to_date(date), Polycon::ProfessionalUtils.beautify_professional_name(professional), name, surname, phone, notes)
          
          #Se crea y llena un archivo de texto plano con extensión .paf en la carpeta del profesional con nombre igual al string de la fecha.
          Polycon::AppointmentUtils.create_appointment_file(
                                                            Polycon::ProfessionalUtils.path_professional_folder(professional) , 
                                                            Polycon::Utils.convert_to_file_convention(new_appointment.date_as_string) ,
                                                            new_appointment
                                                          )
          
          #Se avisa que se creó
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
          #warn "TODO: Implementar detalles de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."

          #Chequear que exista la carpeta polycon en el home del usuario. Si no existe se devuelve un warn y no se sigue la ejecución.
          abort("Ha ocurrido un error, estallo todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Si existe, se busca carpeta del profesional en Dir.home + "/" + ".polycon", Si no existe el profesional, se devuelve un warn.
          abort("El profesional ingresado no existe en nuestro sistema, quizás lo escribiste mal") unless Polycon::ProfessionalUtils.professional_folder_exists?(professional)
          #Si existe, se busca dentro de la carpeta un archivo con el nombre date.paf
          abort("No existe un turno para ese día y hora.") unless Polycon::AppointmentUtils.appointment_file_exists?(
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
          warn "TODO: Implementar borrado de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          #Chequear que exista la carpeta polycon en el home del usuario. Si no existe se devuelve un warn y no se sigue la ejecución.
          #Buscar carpeta del profesional en Dir.home + "/" + ".polycon". Si no existe el profesional se devuelve un warn.
          #Buscar turno en la carpeta, si no existe el turno se devuelve un wanr.
          #Si existe el turno, se procede a borrar el archivo en el folder específico. Seria algo como Dir.home + "/" + ".polycon" + "/" + "profesional" + "/" + "archivo.paf"
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          warn "TODO: Implementar borrado de todos los turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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

        def call(professional:)
          warn "TODO: Implementar listado de turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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
          warn "TODO: Implementar cambio de fecha de turno con fecha '#{old_date}' para que pase a ser '#{new_date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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
          warn "TODO: Implementar modificación de un turno de la o el profesional '#{professional}' con fecha '#{date}', para cambiarle la siguiente información: #{options}.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end

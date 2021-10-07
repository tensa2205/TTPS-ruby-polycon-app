module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          #Chequear root polycon, si no existe se crea.
          Polycon::Utils.create_polycon_root unless Polycon::Utils.polycon_root_exists?
          #Crear el profesional (crear su carpeta basically)
          Polycon::ProfessionalUtils.create_professional_folder(name)
          warn "CREADO"
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
          #Chequear root polycon, si no existe se aborta.
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Chequear que exista el profesional, si existe, se comprueba que no tenga turnos y ahí recién se borra -> se deberian tirar excepciones
          Polycon::ProfessionalUtils.fire_professional(name)
          warn "Profesional despedido"
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          #Chequear root polycon, si no existe se aborta
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Listar los profesionales, si no hay ninguno se tira un mensaje
          Polycon::ProfessionalUtils.list_all_professionals
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"',
        ]

        def call(old_name:, new_name:, **)
          #Chequear root polycon, si no existe se aborta.
          abort("Ha ocurrido un error, estalló todo ya que no existe nuestra base de datos") unless Polycon::Utils.polycon_root_exists?
          #Chequear que exista el profesional.
          abort("No existe el profesional ingresado") unless Polycon::ProfessionalUtils.professional_folder_exists?(old_name)
          #Si existe, se renombra
          Polycon::ProfessionalUtils.rename_professional(old_name, new_name)
          warn "Se cambió el nombre del profesional"
        end
      end
    end
  end
end

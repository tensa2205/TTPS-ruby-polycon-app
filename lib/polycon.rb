module Polycon
  autoload :VERSION, 'polycon/version'
  autoload :Commands, 'polycon/commands'
  autoload :Models, 'polycon/models'
  autoload :Utils, 'polycon/utils.rb'
  autoload :ProfessionalUtils, 'polycon/professional_utils.rb'
  autoload :AppointmentUtils, 'polycon/appointment_utils.rb'
  autoload :TableUtils, 'polycon/table/table_utils.rb'

  # Agregar aquí cualquier autoload que sea necesario para que se cargue las clases y
  # módulos del modelo de datos.
  # Por ejemplo:
  # autoload :Appointment, 'polycon/appointment'
end

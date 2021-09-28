require 'date'
module Polycon
        module Utils #Métodos de ayuda van acá
            def self.ensure_polycon_root_exists
            end

            def self.format_string_to_date(stringDate)
                date = self.validate_string_date(stringDate)
            end

            def self.format_date_to_string(date)
                date.strftime("%F %R")
            end

            def self.validate_string_date(stringDate)
                begin
                    DateTime.parse(stringDate)
                rescue ArgumentError
                    STDERR.puts "La fecha recibida tiene un formato invalido"
                    #El exit a futuro deberia quitarse
                    exit
                end
            end
        end
end

#Polycon::Utils.ensure_polycon_root_exists
#dateObject = Polycon::Utils.format_string_to_date("2021-09-16 13:00")
dateObject = Polycon::Utils.format_string_to_date("2021-09-11")
puts Polycon::Utils.format_date_to_string(dateObject)

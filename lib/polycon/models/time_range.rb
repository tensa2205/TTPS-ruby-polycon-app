module Polycon
    module Models
        class TimeRange
            #Agregar attr_reader
            attr_reader :start, :finish
            def coerce(time)
                #Si es un string, convierte a datetime.
                if time.is_a? String
					time = DateTime.parse(time)
				end
                #Genera el string con H:M
                return time.strftime("%H:%M")
            end
        
            public
        
            def initialize(start,finish)
                @start = coerce(start)
                @finish = coerce(finish)
            end
        
            def include?(time)
                time = coerce(time)
                #Rango donde inicio es < a fin -> inicio..fin
                @start < @finish and return (@start..@finish).include?(time)
                #Caso contrario, capaz se cargó como mayor o igual el inicio. Entonces fin..inicio
                return (@finish..@start).include?(time)
            end

            def self.get_time_ranges(starting_hour, block_quantity, minutes_per_block)
                #Devuelve un array de objetos time_range
                #starting_hour -> hora donde empieza la atención.
                #block_quantity -> cuantos bloques de hora va a haber
                #minutes_per_block -> minutos en total por cada bloque

                time_ranges = [] #el retorno
                start = Time.mktime(Time.now.year,01,01,starting_hour,00) #La hora inicial donde se arranca a atender

                #Genera los minutos especificos
                #Hora (%k -> 0..59) * 60 minutos (genera cant minutos hasta la hora) + minutos de hora actual (innecesario, pero como soy medio inseguro lo dejo)
				minutes_so_far = (start.strftime('%k').to_i * 60) + start.strftime('%M').to_i

                #Genero la cantidad deseada de bloques
				block_quantity.times do
                    second_start = minutes_so_far * 60 #Equivalencia en segundos con minutes_so_far
                    second_finish = (minutes_so_far + minutes_per_block - 1) * 60 #Equivalencia en segundos con minutes_so_far pero se resta 1 minuto
    
                    time_ranges.append(
                        TimeRange.new(
                            Time.mktime(0) + second_start ,
                            Time.mktime(0) + second_finish
                            )
                        )

                    minutes_so_far += minutes_per_block
                end
				time_ranges
            end
        end
    end
end

#puts TimeRange.new("08:00","08:29").include?("08:29")
#puts TimeRange.new("08:30","08:59").include?("08:54") #DEBO GENERAR UN STRING CON FORMATO H:M
#arr = TimeRange.get_time_ranges(8,20,30) #Genera bloques desde 08am hasta 18pm
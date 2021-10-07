module Polycon
    module Models
        class Professional
            #Todos los campos de professional son modificables
            attr_accessor :name
            def initialize(name)
                @name = name
            end

            def to_s
                "Hola, me llamo  %s" % [@name]
            end

            def to_a
                [@name]
            end
        end
    end
end
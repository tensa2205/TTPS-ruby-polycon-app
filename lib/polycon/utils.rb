require 'date'
require 'fileutils'
module Polycon
        module Utils

            def self.polycon_root_exists?
                #Dir.home devuelve el home del usuario que ejecuta.
                # C:/Users/NombreUsuario para w10.
                Dir.exist?(Dir.home << "/" << ".polycon")
            end

            def self.create_polycon_root
                Dir.mkdir(Dir.home << "/" << ".polycon") 
            end

            def self.reports_folder_exist?
                Dir.exist?(Dir.home << "/" << ".polycon-reports")
            end

            def self.create_reports_folder
                Dir.mkdir(Dir.home << "/" << ".polycon-reports")
            end

            #Quizás sea obsoleto a futuro.
            def self.format_date_to_string(date)
                date.strftime("%F %R")
            end

            def self.convert_to_string_from_file_convention(filename)
                #Recibe YYYY-MM-DD_HH-min -> sin el .paf
                filename = filename.gsub!(/_/,' ')
                filename[filename.rindex("-")] = ":"
                filename
            end
            def self.convert_to_file_convention_from_string(string)
                #AAAA-MM-DD_HH-II
                aux_date = self.format_string_to_date(string)
                aux_str = self.format_date_to_string(aux_date)
                self.convert_to_file_convention(aux_str)
            end

            def self.convert_to_file_convention_from_date(date)
                #AAAA-MM-DD_HH-II
                aux_str = self.format_date_to_string(date)
                self.convert_to_file_convention(aux_str)
            end

            def self.convert_to_file_convention(formatted_string)
                #Esto solo funciona con strings ya formateados, no se recomienda usar generalmente por si solo.
                formatted_string.gsub(/:/,'-').gsub(/\s/,'_')
            end

            def self.validate_string_date(stringDate)
                begin
                    DateTime.parse(stringDate)
                rescue ArgumentError
                    STDERR.puts "La fecha recibida tiene un formato invalido"
                    exit
                end
            end

            
            def self.format_string_to_date(stringDate)
                self.validate_string_date(stringDate)
            end

            def self.beautify_string_date(string)
                self.format_date_to_string(self.format_string_to_date(string))
            end

            def self.delete_folder_using_path(path)
                FileUtils.rm_rf(path)
            end

            def self.rename_folder(old_path, new_path)
                File.rename(old_path, new_path)
            end

            def self.get_all_folders_from_path(path)
                Dir.glob(path + "/*").select { |entry| File.directory? entry }
            end

            def self.check_if_any_string_is_empty(*args)
                #Devuelve true si algún parámetro es string vacío
                args.any?{ |param| param.empty? }
            end

            ############################Entrega 2
            def self.string_to_date(stringDate)
                #Date solo, no datetime
                begin
                    Date.parse(stringDate)
                rescue ArgumentError
                    STDERR.puts "La fecha recibida tiene un formato invalido"
                    exit
                end
            end

            def self.date_range_to_hash(date, week = false)
                #Genera los dias necesarios -> puede ser 1 día o 7 días, esto depende del parámetro week.
                date = string_to_date(date)
                range = week ? (date..date+6) : (date..date)
                hash = Hash[ range.map{|date| date.to_s}.collect { |date_converted| [date_converted, [] ] } ]
                hash
            end
        end
end

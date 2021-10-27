require "erb"
module Polycon
    module TableUtils

        #Data de la tabla
        class Table
            def initialize(appointments_day_array, time_range_array)
                @appointments_days = appointments_day_array
                @hours = time_range_array
            end
        
            def get_binding
                binding
            end
        end

        def self.create_template()
            # Create template.
            template = %{
                <!DOCTYPE html>
                <html>
                <style>
                    table, th, td {
                        border:1px solid black;
                        table-layout: auto;
                        width: 500px;
                        text-align: center;
                        padding: 10px;
                    }
                    h2{
                        text-align: center;
                    }
                    th {
                        height: 60px;
                        background-color: orange ;
                        font-size: 22px;
                    }
                    td {
                        height: 60px;
                        width: 200px;

                    }
                    .hours{
                        background-color: #FFC971 ;
                        font-size: 22px;
                        font-weight: bold;
                    }
                </style>
                <body>
                
                <h2> << LISTADO DE TURNOS >> </h2>
                
                <table style="width:100%">
                    <tr>
                        <th class="title__hour">Hora</th>
                        <% @appointments_days.each do |day| %>
                            <th><%= day.date %></th>
                        <% end %>
                    </tr>
                <% @hours.each do |hour| %>
                    <tr>
                        <td class="hours"> <%=hour.start %> </td>
                        <% @appointments_days.each do |day| %>
                            <td> <%=day.get_appointments_in_hour(hour) %> </th>
                        <% end %>
                    </tr>
                <% end %>

                </table>    
                </body>
            </html>
            }.gsub(/^  /, '')
            template
        end
        def self.produce_template_result(appointments, hours)
            rhtml = ERB.new(create_template())
            table = Table.new(appointments, hours)
            res = rhtml.result(table.get_binding)
            res
        end
        def self.export_template_result(appointments, hours)
            template_res = produce_template_result(appointments, hours)
            file_name = Polycon::Utils.convert_to_file_convention_from_date(DateTime.now()) + ".html"
            path = Dir.home + "/" + ".polycon-reports" + "/" + file_name 
            File.open(path ,'w') do |f|
                f.write(template_res)
            end
        end
    end
end
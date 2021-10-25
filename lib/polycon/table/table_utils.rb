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
                    }
                    th {
                        height: 70px;
                    }
                    td {
                        height: 40px;
                    }
                </style>
                <body>
                
                <h2>LISTADO DE TURNOS</h2>
                
                <table style="width:100%">
                    <tr>
                        <th>Hora</th>
                        <% @appointments_days.each do |day| %>
                            <th><%= day.date %></th>
                        <% end %>
                    </tr>
                <% @hours.each do |hour| %>
                    <tr>
                        <td> <%=hour.start %> </td>
                        <% @appointments_days.each do |day| %>
                            <td> <%=day.appointment_in_hour?(hour) %> </th>
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
            file_name = Polycon::Utils.format_date_to_string(DateTime.now())
            puts file_name.class
            File.open("test.html" ,'w') do |f|
                f.write(template_res)
            end
        end
    end
end
=begin 
rhtml = ERB.new(template)
table = Table.new()
# Produce result.
#rhtml.run()
res = rhtml.result(table.get_binding)

File.open('test.html', 'w') do |f|
    f.write(res)
end
=end
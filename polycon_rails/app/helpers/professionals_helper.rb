module ProfessionalsHelper
    def check_deletion(professional)
        professional.appointments.empty?
    end
end

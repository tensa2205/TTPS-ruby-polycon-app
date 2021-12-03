module UsersHelper

    def isConsultaUser?
        current_user.role.name == "Consulta"
    end

    def isAsistenciaUser?
        current_user.role.name == "Asistencia"
    end

    def isAdminUser?
        current_user.role.name == "Administracion"
    end
end

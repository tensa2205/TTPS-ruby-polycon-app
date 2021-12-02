module UsersHelper
    def isNotConsultaUser?
        current_user.role.name != "Consulta"
    end

    def isNotAsistenciaUser?
        current_user.role.name != "Asistencia"
    end

    def isAdminUser?
        current_user.role.name != "Administrador"
    end
end

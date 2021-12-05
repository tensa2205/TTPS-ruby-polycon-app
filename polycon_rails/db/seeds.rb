# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development? #Generar datos para ambiente de desarrollo
    roles = Role.create([
        {name: 'Administracion'},
        {name: 'Asistencia'},
        {name: 'Consulta'}
    ])
    users = User.create([
        {role: roles[0], name: 'Admin', password: 'root'},
        {role: roles[1], name: 'Assistant', password: 'asistente'},
        {role: roles[2], name: 'Consultant', password: 'consultor'}
    ])
end

#rails db:seed me permite cargar la BD con los datos q especifico en este archivo.
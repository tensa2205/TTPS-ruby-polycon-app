# Polycon
## Uso de `polycon`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/polycon`,
el cual puede correrse de las siguientes manera:

```bash
$ ruby bin/polycon [args]
```

O bien:

```bash
$ bundle exec bin/polycon [args]
```

O simplemente:

```bash
$ bin/polycon [args]
```

## Listado de comandos de professionals
Listado de cada comando junto a su propósito:
```
$ ruby bin/polycon professionals
```
Crear profesional:
```
$ ruby bin/polycon professionals "Nombre completo del profesional"
```

Despedir profesional (no se pueden despedir profesionales con turnos pendientes):
```
$ ruby bin/polycon professionals "Nombre completo del profesional a despedir"
```

Listar profesionales de la policlínica:
```
$ ruby bin/polycon professionals list
```

Renombrar profesional:
```
$ ruby bin/polycon professionals "Nombre completo original" "Nombre completo nuevo"
```

## Listado de comandos de appointments
Listado de cada comando junto a su propósito:
```
$ ruby bin/polycon appointments
```

Crear turno:
```
$ ruby bin/polycon appointments create "Fecha del turno en formato YYYY-MM-DD HORA:MINUTOS" --professional="Nombre completo del profesional" --name="Nombre paciente" --surname="Apellido paciente" --phone="Telefono del paciente" --notes="Notas opcionales"
```

Mostrar datos de un turno:
```
$ ruby bin/polycon appointments show "Fecha del turno en formato YYYY-MM-DD HORA:MINUTOS" --professional="Nombre completo del profesional"
```

Cancelar turno:
```
$ ruby bin/polycon appointments cancel "Fecha del turno en formato YYYY-MM-DD HORA:MINUTOS" --professional="Nombre completo del profesional"
```

Cancelar todos los turnos de un profesional:
```
$ ruby bin/polycon appointments cancel-all "Nombre completo del profesional"
```

Listar turnos de un profesional:
```
$ ruby bin/polycon appointments list "Nombre completo del profesional"
```

Reprogramar turno:
```
$ ruby bin/polycon appointments reschedule "Fecha vieja en formato YYYY-MM-DD HORA:MINUTOS" "Fecha nueva en formato YYYY-MM-DD HORA:MINUTOS" --professional="Nombre completo del profesional"
```

Editar información de un turno:
```
#Los parámetros: name, surname, phone y notes son de caracter opcional.
#Solo esa información es modificable, pero al ser opcional, podemos usar cualquiera de los 4 parámetros para hacer modificaciones.
$ ruby bin/polycon appointments "Fecha del turno en formato YYYY-MM-DD HORA:MINUTOS" --professional="Nombre completo del profesional" --name="Nombre paciente" --surname="Apellido paciente" --phone="Telefono del paciente" --notes="Notas opcionales"
```

## Diseño

Basé la mayor parte de la app en hacer código reutilizable en módulos. Esta decisión la tomé por el puro hecho de probar aún más a fondo lo necesario para desarrollar en base a módulos. 

Sí, usé modelo de clases, por ejemplo la clase Appointment, pero esto meramente lo hice para apoyarme sobre ciertas funcionalidades que me proveen las instancias de objetos como puede ser obtener representaciones de todos los atributos en un método to_s o hacer que los atributos de un objeto sean recorridos como si de un array se tratara usando el método to_a.

A remarcar, no le encontré un uso significativo a la clase Professional ya que toda la funcionalidad respectiva a esa parte la pude resolver únicamente usando módulos, dejé la clase ya que es probable que para la segunda entrega si la necesite.

¿Por qué desarrollar usando módulos? Lo que más me interesó de desarrollar en base a módulos fue la reusabilidad que me generaba mientras iba haciendo nuevas funcionalidades. Me pasaba que hubo momentos donde al incluir nuevas funcionalidades pensaba en "bueno, ahora necesito esto" pero me encontraba con que esa necesidad ya la había resuelto anteriormente y ahora podía reusarla sin ningún problema, agilizando así el desarrollo.
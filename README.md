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

Si se agrega el directorio `bin/` del proyecto a la variable de ambiente `PATH` de la shell,
el comando puede utilizarse sin prefijar `bin/`:

```bash
# Esto debe ejecutarse estando ubicad@ en el directorio raiz del proyecto, una única vez
# por sesión de la shell
$ export PATH="$(pwd)/bin:$PATH"
$ polycon [args]
```

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.6 o posterior) y tener instaladas sus dependencias, las cuales se manejan con
> Bundler.

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Bundler se encarga de instalar las dependencias ("gemas")
que el proyecto tenga declaradas en el archivo `Gemfile` al ejecutar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```

Una vez que la instalación de las dependencias sea exitosa, podés comenzar a probar la
herramienta.

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

## Diseño de la entrega 2

Para esta entrega de nuevo utilicé más métodos en base a módulos y nuevas clases. 

Incorporé tres nuevas clases: 
- **TimeRange**: permite instanciar rangos horarios de forma que permite preguntar si una hora en formato Hora:Minutos se encuentra incluida o no
en el rango deseado. A esta clase también le agregué un método de clase que en base a tres parámetros genera un array de rangos horarios,
la aplicación genera la franja horaria desde 08AM hasta 18PM, esto es también modificable.
- **AppointmentsDay**: permite instanciar un "día de turnos" de forma que guarda la fecha y un array de objetos Appointment. Esta clase la usé
principalmente para agrupar todos los turnos en base a fechas.
- **Table**: clase que sirve para recibir todos los datos para después usarlos en el template generado.

También se incorporó el modulo **TableUtils** que contiene la clase Table y otros métodos que tratan la generación y exportación del reporte.

Asunciones respecto del diseño:
- Cada bloque horario es de una duración fija de minutos.
- Los turnos de un mismo profesional no se solaparán en un mismo bloque horario en un mismo día. Pero si en un bloque
hay varios turnos, todos de distintos profesionales entonces sí hay solapamiento, en ese caso la información se muestra de forma correcta.
- Se respetan los rangos horarios de cada bloque, esto gracias a la clase TimeRange.
- La policlínica trabaja todos los dias. Por lo tanto la generación de reportes de una semana específica se dará de la siguiente forma:
    - Si la fecha ingresada es 10/10/2021, se generará un listado de turnos que contemplará el día ingresado y los 6 días siguientes:
        - 10/10/2021 -> 11/10/2021 -> 12/10/2021 -> 13/10/2021 -> 14/10/2021 -> 15/10/2021 -> 16/10/2021.

Para la generación de los reportes se exportan archivos .html en una carpeta llamada .polycon-reports en la carpeta HOME del usuario.
Cada reporte lleva por nombre la fecha y hora exactas de cuando se generó el mismo.
Usando ERB se puede generar texto con código Ruby insertado, de forma que se puede ejecutar dicho código, generando así
los resultados deseados. En este caso, se insertó código Ruby en texto que representa todo el cuerpo de un documento HTML.

## Nuevos comandos

Generar reporte con los turnos de un día específico:
```
#El parámetro --professional es opcional, sirve para filtrar el listado por profesional específico. 
$ ruby bin/polycon appointments list-by-day "Fecha en formato YYYY-MM-DD" --professional="Nombre completo del profesional"
```


Generar reporte con los turnos de una semana específica a partir de un día:
```
#El parámetro --professional es opcional, sirve para filtrar el listado por profesional específico. 
$ ruby bin/polycon appointments list-by-week "Fecha en formato YYYY-MM-DD" --professional="Nombre completo del profesional"
```
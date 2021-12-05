# Polycon
## Uso de `polycon`

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.6 o posterior) y tener instaladas sus dependencias, las cuales se manejan con
> Bundler.

### Manejo de dependencias (correspondiente al paso 2 para usar el proyecto rails)

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


### Seteando todo para estar listos

1. Instalar Rails
```bash
$ gem install rails
```

2. Actualizar las dependencias
```bash
$ bundle install
```
3. Ingresar en la carpeta polycon_rails
```bash
$ cd polycon_rails
```
4. Ejecutar las migraciones que nos pondrán a punto la BD
```bash
$ rails db:migrate
```
5. Ejecutar el seed, esto nos generará 3 usuarios de prueba
```bash
$ rails db:seed
```
6. Credenciales de los 3 usuarios
```bash
USUARIO ADMINISTRADOR:
    Name: admin, Password: root
```
```bash
USUARIO ASISTENTE:
    Name: assistant, Password: asistente
```
```bash
USUARIO CONSULTOR:
    name: consultant, password: consultor
```
7. Para correr la app
```bash
$ rails server
```

8. El comando anterior arranca la aplicación en nuestro entorno local
```bash
    http://127.0.0.1:3000
```


### Funcionalidades

1. CRUD de usuarios (solo admin)
2. CRUD de profesionales
3. CRUD de turnos por cada profesional.
4. Exportar los turnos de todos los profesionales sea por día o por una semana entera.
5. Exportar los turnos de un profesional específico sea por día o por una semana entera.

### Permisos por usuario

1. Administrador:
    - Puede operar sobre todo el sistema.
2. Asistente:
    - Control completo sobre los turnos de los profesionales, solo puede consultar información de los profesionales y no tiene acceso al módulo de usuario.
3. Consultor:
    - Solo puede consultar información del sistema y no tiene acceso al módulo de usuarios.

- Todos pueden exportar la información que necesiten.
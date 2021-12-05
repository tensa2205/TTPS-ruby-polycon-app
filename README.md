# Polycon
## Uso de `polycon`

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

Una vez que la instalación de las dependencias sea exitosa, se prosigue a realizar los pasos a continuación...

### Seteando todo para estar listos

1. Ingresar en la carpeta polycon_rails
```bash
$ cd polycon_rails
```
2. Ejecutar las migraciones que nos pondrán a punto la BD
```bash
$ rails db:migrate
```
3. Ejecutar el seed, esto nos generará 3 usuarios de prueba
```bash
$ rails db:seed
```
4. Credenciales de los 3 usuarios
```bash
USUARIO ADMINISTRADOR:
    Name: Admin, Password: root
```
```bash
USUARIO ASISTENTE:
    Name: Assistant, Password: asistente
```
```bash
USUARIO CONSULTOR:
    name: Consultant, password: consultor
```
5. Para correr la app
```bash
$ rails server
```

6. El comando anterior arranca la aplicación en nuestro entorno local
```bash
    http://127.0.0.1:3000
```
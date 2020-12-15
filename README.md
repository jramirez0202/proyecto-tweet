# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
    2.6.0
* System dependencies



ya creado nuestro proyecto tweet pasamos a ver lo que se requiere

historia 1

1- Una visita debe poder registrarse utilizando el link de registro en la barra de navegación.

Creamos un controlador llamado posts con vista index

rails g controller posts index

En este caso usamos la gema 'devise' en el Gemfile del proyecto para crear la autenticación de usuario. La ponemos en la linea 6 del archivo Gemfile

gem 'devise'

hacemos un 'bundle' en la consola para instalar las dependencias de la gema

bundle install

Debemos instalar la gema 

rails devise:install

instaladas la gema (faltan otras gemas que usaremos) por ahora pasamos a configurarla según la documentación

Al terminar la configuración de 'devise' debemos crear el modelo User para el proyecto

*El modelo debe llamarse user.

rails g devise User

Una vez generada y revisada la cargamos en nuestra base de datos

rails db:migrate

*La visita al registrarse debe ingresar nombre usuario, foto de perfil (url), email y password.

Agregamos los campos name y photo_url al modelo User ya 

rails g migration Add_Params_To_User name:string photo_url:string

revisamos que todo este correcto y procedemos hacer la migración

rails db:migrate

Modificamos los formularios de registro en las vistas new y edit para agregar los campos name, photo_url

app/views/devise/registrations/new.html.erb
app/views/devise/registrations/edit.html.erb

En el controlador de Users en registration "user/registrations" descomentamos los metodos y agregamoos los nuevos campos: 



def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :photo_url])
end

def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :photo_url])
end

Posteriormente debemos modificar la ruta para redirigir hacia el controlador modificado

devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

*Si una visita ya tiene usuario deberá utilizar el link de ingreso y llenará los campos: email y password antes de hacer click en ingresar.


*Al conectarse o registrarse una visita debemos darle la bienvenida asi que modificamos el mensaje signed_in para poner "Bienvenido!"

  config/locales/devise.en.yml 

  signed_in: "Bienvenido!"

  procedemos a crear un usuario en el formulario modificado.

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

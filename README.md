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


  HISTORIA 2

*Una visita debe poder entrar a la página de inicio y ver los últimos 50 tweets.

Creamos una modelo Tweets con content:text con referencia a User para crear una relacion (foreign key) entre tablas tweets.

rails g model tweet user:references content:text

revisamos que todo este correcto y procedemos hacer la migración

rails db:migrate

Agregamos has_many :tweets en el modelo User.rb

*Cada tweet debe mostrar el contenido, la foto del autor (url a la foto), la cantidad de likes y la cantidad de retweets.

Creamos 2 modelos (like y retweet) y hacemos referencias a user y tweet

rails g model like bottom:boolean user:references tweet:references
rails g model retweet user:references tweet:references

agregamos las referencias en el los modelos like y retweet que solo pueden pertenecer a un usuario y a un tweet

creando el boton like

Configuramos una ruta personalizada

put '/tweet/:id/like', to: 'tweets#like', as: 'like'

Creamos un metodo like en nuestro controlador en el creamos el like con user_id y tweet_id luego en nuestro modelo Tweet creamos un metodo liked?(user) para una validacion rápida y luego en el modelo Like una segunda validacion con un scope hacia tweet_id para que no se repita el like en el tweet.

    def liked?(user)
        !!self.likes.find{|like| like.user_id == user.id}        
    end

    validates :user_id, uniqueness: {scope: :tweet_id}

Usamos el metodo user_signed_in? de devise y nuestro método liked? para verificar si el current_user ya dio like a ese tweet para crear un boton de like.

use referencias de https://ichi.pro/es/post/13263942819266

 HISTORIA 3

*Estos tweets deben estar paginados y debe haber un link llamado "mostrar más tweets", al
presionarlo nos llevará a los siguientes 50 tweets.

Para paginar nuestros tweets nos ayudamos con la Gem 'kaminari' siguiendo la documentación procedemos a configurarla

https://github.com/kaminari/kaminari

paginamos los primeros 50 tweets en el modelo tweet.rb

paginates_per 50

configuramos el index del controlador tweets para que muestre los siguientes y previos 50 tweets usando los helpers

<%= link_to_next_page @tweets, 'Show More Tweets' %>
<%= link_to_prev_page @tweets, 'Show Previous Tweets' %>


*HISTORIA 4


Creamos un ruta hacie el formulario new tweet

new_user_registration_path

Usamos el user_signed_in? en el index y el before_action :authenticate_user!  para confirmar que el usuario este conectado y no sea una visita.

validamos que el tweet tenga contenido con un validates :content, presence: true en el modelo tweet.rb

creamos metodo create para like al final de la condicion usamos un redirect_to root_path para llevarnos a la pagina inicial.

creamos los metodos dislike y like y Agregamos el campo button como booleano para usarlo como un switch donde true aplicará el metodo like y false dislike asi evitamos que el mismo user_id y tweet_id repitan la acción

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

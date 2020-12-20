# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
    2.6.0
* System dependencies



ya creado nuestro proyecto tweet pasamos a ver lo que se requiere



*Una visita debe poder registrarse utilizando el link de registro en la barra de navegación.

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


*Si una visita ya tiene usuario deberá utilizar el link de ingreso y llenará los campos: email y password antes de hacer click en ingresar.


*Al conectarse o registrarse una visita debemos darle la bienvenida asi que modificamos el mensaje signed_in para poner "Bienvenido!"

  config/locales/devise.en.yml 

  signed_in: "Bienvenido!"

  procedemos a crear un usuario en el formulario modificado.



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

*Estos tweets deben estar paginados y debe haber un link llamado "mostrar más tweets", al
presionarlo nos llevará a los siguientes 50 tweets.

Para paginar nuestros tweets nos ayudamos con la Gem 'kaminari' siguiendo la documentación procedemos a configurarla

https://github.com/kaminari/kaminari

paginamos los primeros 50 tweets en el modelo tweet.rb

paginates_per 50

configuramos el index del controlador tweets para que muestre los siguientes y previos 50 tweets usando los helpers

<%= link_to_next_page @tweets, 'Show More Tweets' %>
<%= link_to_prev_page @tweets, 'Show Previous Tweets' %>



*Al principio de la página debe haber una formulario que nos permita ingresar un nuevo
tweet, al crear un tweet el usuario será redirigido a la página de inicio.

Creamos un ruta hacia el formulario new tweet 

new_user_registration_path

*El formulario solo debe mostarse a los usuarios y no a las visitas.

Usando un user_signed_in? validamos que este conectado el usuario y condicionamos las vistas para visitas dentro de la vista index de tweets.
Usamos el user_signed_in? en el index y el before_action :authenticate_user!  para confirmar que el usuario este conectado y no sea una visita.
validamos el contenido del tweet con un validación .

validates :content, presence: true

*Se debe validar que el tweet tenga contenido.

validamos que el tweet tenga contenido en el modelo tweet.rb

validates :content, presence: true 

*Un usuario puede hacer like en un tweet, al hacerlo será redirigido a la página de inicio

agregamos un icono de https://fontawesome.com/icons?d=gallery&q=pets para el like

creamos el metodo create para like controller  al final de la condicion usamos un redirect_to root_path para llevarnos a la pagina inicial cuando se de like.

creamos los metodos dislike/like y Agregamos en el modelo la variable button como booleano para usarlo como un switch donde true aplicará el metodo like y false dislike asi evitamos que el mismo user_id y tweet_id repitan la acción con Like.find_by buscando los id de user y tweets. Tambien creamos las asociaciones correnpodientes 1 a N con los modelos user y tweet

usamos referencias
https://medium.com/swlh/add-dynamic-like-dislike-buttons-to-your-rails-6-application-ccce8a234c43
https://gorails.com/episodes/liking-posts?autoplay=1
https://ichi.pro/es/post/13263942819266

*Un usuario puede hacer un retweet haciendo click en la acción rt (retweet) de un tweet, esto hará que ingrese un nuevo tweet con el mismo contenido pero además referenciando al tweet original.

Creamos el modelo retweet con sus asociaciones correspondientes hacia user y tweet, en el tweet controller creamos el metodo retweet donde creamos el tweet y usamos el metodo set_tweet para tomar user_id y tweet_id usamos el current_user para crear un nuevo retweet y guardamos. creamos el rt donde interpolamos el usuario y hacemos referencia al mismo sumando 1 rt al mismo para contener el contenido original y guardamos

Haciendo click en la fecha del tweet se debe ir al detalle del tweet y dentro del detalle debe
aparecer la foto de todas las personas que han dado like al tweet.

en la vista show recorremos el arreglo en like para traernos todas las fotos de los usuarios que dieron like.


*La fecha del tweet debe aparecer como tiempo en minutos desde la fecha de creación u horas si es mayor de 60 minutos
 
Usamos los metodos que trae rails y con los videos de la clase como guia la hora la usamos como link hacia la vista tweet_path
<%= link_to distance_of_time_in_words(Time.now, tweet.created_at), tweet_path(tweet.id) %>

* Configuration

* Database creation

  create_table "likes", force: :cascade do |t|
    t.boolean "button", default: true
    t.integer "user_id"
    t.integer "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_likes_on_tweet_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "retweets", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "tweet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_retweets_on_tweet_id"
    t.index ["user_id"], name: "index_retweets_on_user_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.integer "global_likes", default: 0
    t.index ["user_id"], name: "index_tweets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "photo_url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "likes", "tweets"
  add_foreign_key "likes", "users"
  add_foreign_key "retweets", "tweets"
  add_foreign_key "retweets", "users"
  add_foreign_key "tweets", "users"

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

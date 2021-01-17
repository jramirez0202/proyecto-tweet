# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
    2.6.6
* System dependencies


Bienvenido 

Rails new proyecto

ya creado nuestro proyecto tweet pasamos a ver lo que se requiere



*Una visita debe poder registrarse utilizando el link de registro en la barra de navegación.

Creamos un controlador llamado tweets con vista index

rails g controller tweets index

En este caso usamos la gema 'devise' en el Gemfile del proyecto para crear la autenticación de usuario. La ponemos en la linea 6 del archivo Gemfile

gem 'devise'

hacemos un 'bundle' en la consola para instalar las dependencias de la gema

bundle install

Debemos instalar la gema por consola

rails devise:install

instaladas la gema (faltan otras gemas que usaremos) por ahora pasamos a configurarla según la documentación

Al terminar la configuración de 'devise' debemos crear el modelo User para el proyecto

*El modelo debe llamarse user.

rails g devise User

Una vez generada y revisada la cargamos en nuestra base de datos

rails db:migrate

*La visita al registrarse debe ingresar nombre usuario, foto de perfil (url), email y password.

Agregamos los campos name y photo_url al modelo User ya creado

rails g migration Add_Params_To_User name:string photo_url:string

revisamos que todo este correcto y procedemos hacer la migración

rails db:migrate

Modificamos los formularios de registro en las vistas new y edit para agregar los campos name, photo_url

app/views/devise/registrations/new.html.erb
app/views/devise/registrations/edit.html.erb


*Si una visita ya tiene usuario deberá utilizar el link de ingreso y llenará los campos: email y password antes de hacer click en ingresar.

mostramos los links de sign_in y registration en el navbar


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

*Hacer que un usuario conectado pueda seguir a otros usuarios y tener acceso a su contenido

creamos el modelo friend con follower_id y followed_id para asociarlo al modelo user con has_many

rails g model Friend follower_id:integer followed_id:integer

otra forma de hacerlo con referencias 

rails g model Friend follower_id:integer followed_id:integer references: user

usamos referencias 
https://levelup.gitconnected.com/how-to-create-a-follow-unfollow-button-in-your-rails-social-media-application-e4081c279bca
En user.rb creamos la asociacion 1 a N con la llave foranea de follower_id

  has_many :followers, class_name: 'Friend', foreign_key: 'user_id'
  has_many :following, class_name: 'Friend', foreign_key: 'friend_id'

  asociamos con friend.rb

    belongs_to :user, class_name: 'User'
    belongs_to :friend, class_name: 'User'

En friend.rb 

Debemos implementar las rutas para el mismo 

  resources :tweets do
    member do
      post 'follow/:id', to: 'tweets#follow', as: 'follow'
    end
  end

Tenemos asociacion entre modelos tambien tenemos la ruta ahora vayamos al controlador de tweets (tweets_controller.rb) y agregamos los metodos para cada caso 
  
  # Metodos follow y unfollow
  
  def follow
    user = User.find(params[:id])
    follows = Friend.new(user: user, friend: current_user)
    follows.save
    redirect_to root_path
  end

  def destroy_following
    user = User.find(params[:id])
    friend = current_user.users_i_follow(user)
    friend.destroy
    redirect_to root_path
  end

  Tambien en el modelo user agregamos los metodos para que cada modelo busquen el id unico del usuario y no se repita.

    def user_following_me(user)
    self.followers.find_by(friend_id: user.id)
  end
      
  def users_i_follow(user)
    self.following.find_by(user_id: user.id)
  end

  Debemos agregarlo a nuestro index y lo condicionamos de la siguiente manera

              <%if user_signed_in? %>
                  <% unless tweet.user.user_following_me(current_user) %>
                      <span><%= button_to  "Follow", follow_tweet_path(tweet.user.id), method: :post, class: "tweet--date" %></span>
                  <% end%>
                <% if current_user.users_i_follow(tweet.user) %>
                      <span><%= button_to  "Unfollow", destroy_following_path(tweet.user.id), method: :delete, class: "tweet--date" %></span>
                <%end%>
              <%end %>

*Implementar un buscador que pueda buscar tweets, para esto se debe hacer una búsqueda
parcial ya que el contenido puede ser solo parte de un tweet.

Usamos un formulario para la barra de busqueda en el creamos un action con ruta al root "/", como queremos que nuestra barra de busqueda filtre los contenido de los tweets y no una palabra especifica colocamos el name= :q para pasarlo los datos del tweet espeficicamente el contenido del tweet para luego buscar los params[:q] del mismo.

<input class="form-control mr-sm-2" type="search" placeholder="Search Twitter" aria-label="Search" name="q">

En el tweets_controller.rb en el metodo index, validamos la presencia de los params de ser asi usamos una variable llamada "search" para agregar los params de :q para luego hacer una busqueda en la columna content del modelo tweet e interpolamos la variable con los params[:q]

  def index
    @tweet = Tweet.new
    if params[:q].present?
      search = params[:q]
      @tweets = Tweet.where('content LIKE ?', "%#{search}%")
    else
      @tweets = Tweet.page params[:page]
      @tweets = Tweet.includes(:tweet, :user, :retweets).order("updated_at DESC").page
    end
  end

  probemos la barra de busqueda.

Instalando la gema ActiveAdmin para gestion de la RRSS

En este paso debemos instalar la gem ActiveAdmin en nuestro gemfile hacemos bundle y siguiendo la documentacion instalamos con la consola.
Debemos agregar los modelos Tweet y User para la gestion del usuario admin, debemos agregar las columnas en app/admin/tweets.rb para informacion a detalle de lo que se publica en la RRSS y los params permitidos para el mismo 

  permit_params :content, :user_id, :global_likes

  index do
    column :user_id
    column :name do |tweet|
    tweet.user.name
    end
    column :content
    column :retweets do |tweet|
    tweet.retweets.count
    end
    column :likes do |tweet|
    tweet.likes.count
    end
    column :folowers_id do |tweet|
    tweet.user.followers.count  
    end
    column :folowings_id do |tweet|
      tweet.user.following.count
      end
    actions
  end

  Para agilizar la busqueda colocamos un filtro con create_at

  filter :created_at, as: :date_range

  En app/admin/users.rb se agrega un bloque para un crear un nuevo usuario y para eliminar 

    form do |f|
      inputs 'Add new user' do
      input :email
      input :name
      input :password
      actions
    end
  end
    
  controller do
  def update
    if (params[:user][:password].blank? && params[:user]
        [:password_confirmation].blank?)
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
    end
        super
    end
  end

  Tambien los parametros permitidos para users con un par de filtros para ayudar a la busqueda de usuarios.

    permit_params :email, :name, :password

  filter :email, as: :select
  filter :name


  creacion del hashtag para los tweets

  Creamos un modelo llamado tag para referenciarlo al modelo ya creado tweets.rb pero con la diferencia que esta asociacion sera de N a N veamos

  rails g model Tag name:string

  rails db:migrate

  luego hacemos una migracion donde creamos tags_tweets que con refrencias a tag y a tweets en ese orden 

  rails migration CreateTagsTweets references: tags references tweets

  class CreatesTagsTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tags_tweets, id: false do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :tweet, index: true, foreign_key: true
    end
  end
end

En tweets.rb y tags.rb agregamos las referencias anteriomente nombradas de N a N

has_and_belongs_to_many :tags

has_and_belongs_to_many :tweets


Luego agragamos dos bloques de codigo para evaluar contenido antes y y despues de crear 

  after_create do
        tweet = Tweet.find_by(id: self.id)
        hashtags = self.content.scan(/#\w+/)
        hashtags.uniq.map do |hashtag|
            tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
            tweet.tags << tag
        end
    end


    before_update do
        tweet = Tweet.find_by(id: self.id)
        hashtags = self.content.scan(/#\w+/)
        hashtags.uniq.map do |hashtag|
            tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
            tweet.tags << tag
        end
    end

 Antes de crear y despues se evalua que sea el id del mismo tweet luego la variable hashtag revisa el contenido buscando el caracter # luego hace luego itera con la variable tag que busca o crea en name (recordemos lo definimos en el modelo tag como string) con el downcase converitimos el string en minusculas y al final se hace un push hacia tweets.tag


 debemos crear la ruta donde van a estar los hashtags en routes.rb



  get '/tweets/hashtag/:name', to:'tweets#hashtags'

  ahora vamos al controlador tweet y creamos el metodo hastags y creamos su vista hashtags.html.erb

    def hashtags
    tag = Tag.find_by(name: params[:name])
    @tweets = tag.tweets.page
  end

  y agregamos un metodo al tweets_helper.rb 

      def render_with_hashtags(content)
        content.gsub(/#\w+/){ |word| link_to word, "/tweets/hashtag/#{word.downcase.delete('#')}"}.html_safe
    end

  En la vista hashtags.html.erb

  ponemos la vista index y el el render del metodo que pusimos en el helper anteior

  <p><%= render_with_hashtags(tweet.content) %></p>


  hito 3

  Creramos un api controller con un metodo news y heredamos de ActionController::API la clase de manera manual.

  en routes.rb

  creamos la siguiente ruta para el end point 

    post 'api/news'

  en el metodo news vamos a traer todos los tweets lo iteramos luego agregamos a un hash y y los agregamos con un push a una array vacio que previamente creado damos la informacion de cada punto y renderisamos en json para verlo en postman 

  class ApiController < ActionController::API 
  def news
    @tweet = Tweet.all
    array = []
    all = { tweet:   
      @tweet.sort.each do |tweet|
      array << { id: tweet.id,
                content: tweet.content,
                user_id: tweet.user_id,
                like_count: tweet.likes.count,
                retweets_count: tweet.retweets.count,
                rewtitted_from: tweet.user.id
      }
    end }

    render json: array
  end
end

para revisar este end point abrimos la herramienta postman 

Pegamos la direccion: http://localhost:3000/api/news con GET (recuerden la routa creada  get 'api/news')


Presionamos SEND para hacer la consulta y nos trae los tweets con informacion solicitada


Para hacer una consulta en algun rango de fechas se usa el formato de fecha AAAA-MM-DD donde el inicio de fecha lo llamado startDate y el otro lo llamados endDate 2021-01-06

Entramos a postman usamos el mismo endpoint de date_ranges pero pidiendo las fechas que deseamos revisar 

http://localhost:3000/api/dates_ranges/2021-01-03/2021-01-09


 Presionamos SEND para ver los Tweets dentro de ese rango de fechas o cualquier otra fecha


 creando un tweet vamos al postman usamos la ruta en POST

 http://localhost:3000/tweets 

 en body de postman pegamos

 {
    "tweet":{
        "content": "soy un tweet"
    }
}

no ubicamos en el boton en raw y mostramos


 usamos de referencia https://medium.com/@nahrivera7/autenticaci%C3%B3n-con-rails-6-0-d1067ef687f4




* Configuration

* Database creation

create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "friends", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friend_id"], name: "index_friends_on_friend_id"
    t.index ["user_id"], name: "index_friends_on_user_id"
  end

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

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags_tweets", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "tweet_id"
    t.index ["tag_id"], name: "index_tags_tweets_on_tag_id"
    t.index ["tweet_id"], name: "index_tags_tweets_on_tweet_id"
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

  add_foreign_key "friends", "users"
  add_foreign_key "friends", "users", column: "friend_id"
  add_foreign_key "likes", "tweets"
  add_foreign_key "likes", "users"
  add_foreign_key "retweets", "tweets"
  add_foreign_key "retweets", "users"
  add_foreign_key "tags_tweets", "tags"
  add_foreign_key "tags_tweets", "tweets"
  add_foreign_key "tweets", "users"
end

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

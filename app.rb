
require 'rubygems'
require "sinatra"
require 'sinatra/activerecord'
require 'sqlite3'
require 'bcrypt'
require './config/environments' #database configuration
require "./model.rb"

#set :root, File.dirname(__FILE__)
enable :sessions
set :session_secret, "My session secret"

def is_number?(obj)
    obj.to_s == obj.to_i.to_s
end

get "/" do
  session[:user] = User.last
  erb :index
end

post "/create_post" do
  @post = Post.create user: session[:user], title: params[:title]
  @comment = Comment.create user: session[:user], gif_path: params[:gif_path], message: params[:message], post: @post
  @post.comments.push @comment
  redirect to("/post/#{@post.id}")
end

get "/post/:id" do
  if is_number? params[:id]
    @post = Post.find(params[:id])
    erb :post
  else
    "Not a Valid Post"
  end
end

##ActiveRecords
class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
end
class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: "Comment"
  has_many :children, class_name: "Comment", foreign_key: "parent_id"
  validates_presence_of :gif_path, :user, :message, :post
  #user :id
  #post :id
  #gif_path :string
  #message  :string
  #parent :id
  #comments   :ids

  def make_html
		original = '
		Test
		'
		self.children.each do |c|
			original += c.make_html
		end
		original
	end
end
class User < ActiveRecord::Base
  include BCrypt

  has_many :posts
  has_many :comments

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end

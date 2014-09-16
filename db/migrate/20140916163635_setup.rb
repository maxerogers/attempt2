class Setup < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_hash
      t.string :password_salt
    end
    create_table :posts do |t|
      t.string :title
      t.references :user
    end
    create_table :comments do |t|
      t.string :message
      t.string :gif_path
      t.references :user
      t.references :post
      t.belongs_to :parent
      t.integer :tier
      t.timestamps
    end
  end
end

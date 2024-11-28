class SorceryCore < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email,            null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.string :user_name, null: false
      t.string :avater_image
      t.string :profile

      t.timestamps
    end
  end
end

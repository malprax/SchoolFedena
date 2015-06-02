class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :admin
      t.boolean :student
      t.boolean :employee
      t.string :hashed_password
      t.string :salt
      t.string :reset_password_code
      t.datetime :reset_password_code_until

      t.timestamps null: false
    end
  end
end

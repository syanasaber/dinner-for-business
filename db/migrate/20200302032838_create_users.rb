class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :job_field
      t.string :job_class
      t.string :my_area1
      t.string :my_area2
      t.string :my_area3

      t.timestamps
    end
  end
end

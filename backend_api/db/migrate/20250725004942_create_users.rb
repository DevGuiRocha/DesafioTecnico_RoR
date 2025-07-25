class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.integer :access_level, null: false, default: 0

      t.timestamps
    end

    add_index :users, :external_id, unique: true
    add_index :users, :email, unique: true
  end
end

class AddUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :vendors do |t|
      t.string :name
      t.integer :external_id
      t.timestamps
    end
  end
end

class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :tags, :value, unique: true
  end
end

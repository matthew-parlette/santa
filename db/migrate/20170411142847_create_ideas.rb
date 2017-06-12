class CreateIdeas < ActiveRecord::Migration[5.0]
  def change
    create_table :ideas do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.references :created_by, foreign_key: true
      t.boolean :private, default: false

      t.timestamps
    end
  end
end

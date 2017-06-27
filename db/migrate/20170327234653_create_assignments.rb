class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.references :user, foreign_key: true
      t.references :assigned_to, foreign_key: true
      t.integer :year

      t.timestamps
    end
  end
end

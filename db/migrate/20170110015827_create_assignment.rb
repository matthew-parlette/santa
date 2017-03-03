class CreateAssignment < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.string :year
      t.references :user, foreign_key: true
      t.references :assignment, references: :user

      t.timestamps
    end
  end
end

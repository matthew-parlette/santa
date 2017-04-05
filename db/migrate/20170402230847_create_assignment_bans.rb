class CreateAssignmentBans < ActiveRecord::Migration[5.0]
  def change
    create_table :assignment_bans do |t|
      t.references :user, foreign_key: true
      t.references :assigned_to, foreign_key: true

      t.timestamps
    end
  end
end

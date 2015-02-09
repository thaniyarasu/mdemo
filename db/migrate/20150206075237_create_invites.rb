class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :name
      t.string :document

      t.timestamps null: false
    end
  end
end

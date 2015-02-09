class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :subject
      t.text :message
      t.text :recipients
      t.text :call
      t.text :audio
      t.text :voice
      t.timestamps null: false
    end
  end
end

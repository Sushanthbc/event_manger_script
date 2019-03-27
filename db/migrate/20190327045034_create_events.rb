class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :rsvp
      t.boolean :all_day
      t.string :event_completed
      t.references :user
      t.timestamps
    end
  end
end

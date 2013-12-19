class CreateFeedback < ActiveRecord::Migration
  def up
    create_table(:feedbacks) do |t|
      t.string    "description"
      t.string    "subscription"
      t.datetime  "member_since"
      t.timestamps
    end
  end

  def down
    drop_table :feedbacks
  end
end

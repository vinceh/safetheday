class Blog < ActiveRecord::Migration
  def change
    create_table(:posts) do |t|
      t.text      :body
      t.string    :title
      t.string    :hero_image
      t.string    :thumbnail_image
      t.timestamps
    end
  end
end

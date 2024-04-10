class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.references :user, null: false, foreign_key: true
      t.string :youtube_id, null: false
      t.string :title
      t.string :description
      t.string :thumbnail_url
      t.string :url, null: false

      t.timestamps
    end

    add_index :movies, :youtube_id, unique: true
    add_index :movies, :url, unique: true
  end
end

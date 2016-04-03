class StoryMigration < ActiveRecord::Migration

  def up
    drop_table :stories if table_exists?(:stories)
    create_table :stories do |t|
      t.string :name
      t.timestamps null: true
    end
  end

  def down
    drop_table :stories if table_exists?(:stories)
  end
end

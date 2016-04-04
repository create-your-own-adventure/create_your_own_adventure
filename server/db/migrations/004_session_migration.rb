class SessionMigration < ActiveRecord::Migration

  def up
    drop_table :sessions if table_exists?(:sessions)
    create_table :sessions do |t|
      t.string   :token
      t.timestamps null: true
    end
  end

  def down
    drop_table :sessions if table_exists?(:sessions)
  end
end

class CreateCocks < ActiveRecord::Migration[6.1]
  def change
    create_table :cocks do |t|
      t.string :size
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :cocks, [:user_id, :created_at]
  end
end

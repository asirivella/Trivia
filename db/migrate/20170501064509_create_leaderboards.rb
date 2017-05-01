class CreateLeaderboards < ActiveRecord::Migration[5.0]
  def change
    create_table :leaderboards do |t|
      t.integer :user_id
      t.string :email
      t.string :tag
      t.integer :score

      t.timestamps
    end
  end
end

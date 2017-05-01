class AddUserIdIndexToArticles < ActiveRecord::Migration[5.0]
  def change
    add_index :articles, :user_id
  end
  
  def change
    add_index :leaderboards, :user_id
  end
end

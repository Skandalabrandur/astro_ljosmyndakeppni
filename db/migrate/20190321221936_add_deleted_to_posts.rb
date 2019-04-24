class AddDeletedToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :deleted, :boolean
  end
end

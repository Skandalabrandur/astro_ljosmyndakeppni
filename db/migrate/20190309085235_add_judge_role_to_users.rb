class AddJudgeRoleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :judge, :boolean
  end
end

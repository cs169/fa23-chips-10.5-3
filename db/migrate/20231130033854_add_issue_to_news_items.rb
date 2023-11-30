class AddIssueToNewsItems < ActiveRecord::Migration[5.2] # version may vary
  def change
    add_column :news_items, :issue, :string
  end
end

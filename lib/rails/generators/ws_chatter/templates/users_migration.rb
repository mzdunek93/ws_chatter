class Add<%= status_column.camelize %>To<%= table_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :<%= status_column %>, :boolean, default: false
  end
end

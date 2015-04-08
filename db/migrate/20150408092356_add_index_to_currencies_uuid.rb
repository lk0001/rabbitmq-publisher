class AddIndexToCurrenciesUuid < ActiveRecord::Migration
  def change
    add_index :currencies, :uuid
  end
end

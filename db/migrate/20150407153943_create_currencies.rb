class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.text :uuid
      t.json :rates
      t.text :base
      t.boolean :c1_success, default: false
      t.boolean :c2_success, default: false
      t.boolean :c3_success, default: false

      t.timestamps
    end
  end
end

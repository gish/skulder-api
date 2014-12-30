class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.integer :amount
      t.string :description
      t.integer :collector_id
      t.integer :loaner_id
      t.string :uuid
      t.timestamps null: false
    end
  end
end

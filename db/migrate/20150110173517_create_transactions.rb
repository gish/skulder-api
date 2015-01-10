class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :uuid
      t.integer :recipient_id
      t.integer :sender_id
      t.integer :balance
      t.string :description

      t.timestamps null: false
    end
  end
end

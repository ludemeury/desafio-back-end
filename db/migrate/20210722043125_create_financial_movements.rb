class CreateFinancialMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_movements do |t|
      t.integer :kind
      t.datetime :done_at
      t.float :value
      t.string :card
      t.references :shop, foreign_key: true

      t.timestamps
    end
  end
end

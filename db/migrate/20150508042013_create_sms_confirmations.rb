class CreateSmsConfirmations < ActiveRecord::Migration
  def change
    create_table :sms_confirmations do |t|
      t.string :phone
      t.string :confirmation_key

      t.timestamps
    end
  end
end

class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.string :name
      t.integer :port
    end
  end

  def self.down
    drop_table :applications
  end
end

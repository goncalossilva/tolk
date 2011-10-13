class AddDescriptionToTolkLocales < ActiveRecord::Migration
  def self.up
    add_column :tolk_locales, :description, :string
  end

  def self.down
    remove_column :tolk_locales, :description
  end
end

class CreateCensusData < ActiveRecord::Migration
  def change
    create_table :census_data do |t|
      t.integer :report_id
      t.integer :workclass_id
      t.integer :education_level_id
      t.integer :marital_status_id
      t.integer :occupation_id
      t.integer :relationship_id
      t.integer :race_id
      t.integer :sex_id
      t.integer :country_id
      t.float   :age, precision: 3, scale: 1
      t.float   :education_num, precision: 1, scale: 1
      t.float   :capital_gain, precision: 5, scale: 2
      t.float   :capital_loss, precision: 4, scale: 2
      t.float   :hours_week, precision: 3, scale: 1
      t.boolean :over_50k, null: false, default: false
      t.string  :country
      t.string  :education_level
      t.string  :marital_status
      t.string  :occupation
      t.string  :race
      t.string  :relationship
      t.string  :sex
      t.string  :workclass

      t.timestamps
    end
  end
end

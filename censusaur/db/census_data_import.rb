require 'csv'
class CensusDataImport

  CSV_FILE = 'db/import_data/denormalized_census_data_1996.csv'

  def self.batch_import(filename, batch_size=100, batch_limit=nil)
    batch_size = batch_size.to_i
    rows = []
    batch_counter = 1
    db_records_count_start = CensusData.count
    csv_rows = IO.readlines(filename).size
    CSV.foreach(filename, headers: true, skip_blanks: true, header_converters: :symbol) do |row|
      unless batch_counter == batch_limit.to_i
        rows << row
        if rows.size == batch_size
          self.load(rows)
          rows = []
          batch_counter += 1
        end
      end
    end
    db_records_count_start_end = CensusData.count
    new_records = db_records_count_start_end - db_records_count_start
    puts "Imported #{ new_records } new records (Total: #{ db_records_count_start_end }). #{ new_records } of #{ csv_rows - 1 } lines. #{ csv_rows - new_records - 1 } lines missing!"
  end

  def self.load(rows)
    connection = ActiveRecord::Base.connection
    ActiveRecord::Base.transaction do
      i = 0
      rows.each do |row|
        report_id =          row[:id]
        age =                row[:age]
        capital_gain =       row[:capital_gain]
        capital_loss =       row[:capital_loss]
        hours_week =         row[:hours_week]
        education_num =      row[:education_num]
        over_50k =           row[:over_50k]
        country_id =         row[:country_id]
        education_level_id = row[:education_level_id]
        marital_status_id =  row[:marital_status_id]
        occupation_id =      row[:occupation_id]
        race_id =            row[:race_id]
        relationship_id =    row[:relationship_id]
        sex_id =             row[:sex_id]
        workclass_id =       row[:workclass_id]
        country =            row[:country]
        education_level =    row[:education_level]
        marital_status =     row[:marital_status]
        occupation =         row[:occupation]
        race =               row[:race]
        relationship =       row[:relationship]
        sex =                row[:sex]
        workclass =          row[:workclass]

        sql = "INSERT INTO census_data (report_id,
                                        age,
                                        capital_gain,
                                        capital_loss,
                                        hours_week,
                                        education_num,
                                        over_50k,
                                        country_id,
                                        education_level_id,
                                        marital_status_id,
                                        occupation_id,
                                        race_id,
                                        relationship_id,
                                        sex_id,
                                        workclass_id,
                                        country,
                                        education_level,
                                        marital_status,
                                        occupation,
                                        race,
                                        relationship,
                                        sex,
                                        workclass,
                                        created_at,
                                        updated_at)

             VALUES                    (#{ report_id },
                                        COALESCE(#{ age }, 0)::float,
                                        COALESCE(#{ capital_gain }, 0)::float,
                                        COALESCE(#{ capital_loss }, 0)::float,
                                        COALESCE(#{ hours_week }, 0)::float,
                                        COALESCE(#{ education_num }, 0)::float,
                                        CASE
                                        WHEN #{ over_50k } = 1
                                        THEN TRUE
                                        ELSE FALSE
                                        END,
                                        #{ country_id },
                                        #{ education_level_id },
                                        #{ marital_status_id },
                                        #{ occupation_id },
                                        #{ race_id },
                                        #{ relationship_id },
                                        #{ sex_id },
                                        #{ workclass_id },
                                        TRIM(BOTH ' ' FROM $$#{ country }$$),
                                        TRIM(BOTH ' ' FROM $$#{ education_level }$$),
                                        TRIM(BOTH ' ' FROM $$#{ marital_status }$$),
                                        TRIM(BOTH ' ' FROM $$#{ occupation }$$),
                                        TRIM(BOTH ' ' FROM $$#{ race }$$),
                                        TRIM(BOTH ' ' FROM $$#{ relationship }$$),
                                        TRIM(BOTH ' ' FROM $$#{ sex }$$),
                                        TRIM(BOTH ' ' FROM $$#{ workclass }$$),
                                        NOW(),
                                        NOW()
             )"
        connection.execute(sql)
        i += 1
        # puts i # uncomment to debug batches
      end
    end # CSV.foreach
  end # self.load
end

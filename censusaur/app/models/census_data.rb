class CensusData < ActiveRecord::Base

  # TODO - DRY up these methods
  def self.by_country_and_education_level_and_over_50k_and_sex
    # ordering education_level alphanumeric required prepending a "0" to single-digit values
    self.order(["census_data.country",
                "census_data.sex",
                "census_data.over_50k",
                "REGEXP_REPLACE(LEFT(LOWER(education_level), 2),
                                '(\d)\D',
                                0 || LEFT(LOWER(education_level), 1))"]).
         group(["census_data.country",
                "census_data.over_50k",
                "census_data.education_level",
                "census_data.education_level_id",
                "census_data.sex"]).
         pluck("census_data.country",
               "census_data.over_50k",
               "census_data.education_level",
               "census_data.sex",
               "count('census_data.sex')")
  end

  def self.by_sex_and_education_and_over_50k
    self.
    # ordering education_level alphanumeric required prepending a "0" to single-digit values
    order(["census_data.sex",
           "census_data.over_50k",
           "REGEXP_REPLACE(LEFT(LOWER(education_level), 2),
                           '(\d)\D',
                           0 || LEFT(LOWER(education_level), 1))"]).
    group(["census_data.over_50k",
           "census_data.education_level",
           "census_data.education_level_id",
           "census_data.sex"]).
    pluck("census_data.over_50k",
          "census_data.education_level",
          "census_data.sex",
          "count('census_data.sex')")
  end

  def self.country_salary_gender_table
    # attempting to handroll data for Google chart (https://developers.google.com/chart/interactive/docs/gallery/combochart)
    summary_table_data = []
    headers = ["Country", "Women 50k+", "Men 50k+", "Women < 50k", "Men < 50k", "Average"]
    summary_table_data << headers
    women_over_50k = 0
    men_over_50k = 0
    women_under_50k = 0
    men_under_50k = 0
    self.by_country_and_education_level_and_over_50k_and_sex.group_by{|g| g[0]}.each do |country_dataset|
      country_dataset[1].each do |country_totals|
        country  = country_totals[0]
        over_50k = country_totals[1]
        education_level = country_totals[2]
        gender = country_totals[3]
        count = country_totals[4]

        if over_50k == true && gender == "Female"
          women_over_50k += 1 * count
        elsif over_50k == true && gender == "Male"
          men_over_50k += 1 * count
        elsif over_50k == false && gender == "Female"
          women_under_50k += 1 * count
        elsif over_50k == false && gender == "Male"
          men_under_50k += 1 * count
        end
        totals = [women_over_50k, men_over_50k, women_under_50k, men_under_50k]
        average = totals.inject(0.0) { |sum, i| sum + i } / totals.size
        summary_row = [country, women_over_50k, men_over_50k, women_under_50k, men_under_50k, average]
        summary_table_data << summary_row
      end
    end
    summary_table_data
  end
end

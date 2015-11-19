class CensusDataController < ApplicationController
  before_action :census_data_variable_and_count
  def index
  end

  def charts

    @census_by_sex_and_education_and_salary = CensusData.by_sex_and_education_and_over_50k
    @census_by_country_and_sex_and_education_and_salary = CensusData.by_country_and_education_level_and_over_50k_and_sex
    # @by_country_and_over_50k_and_sex_and_education_level = CensusData.by_country_and_over_50k_and_sex_and_education_level
  end

  private
  def census_data_variable_and_count
    @census_data = CensusData.paginate(page: params[:page], :per_page => 500)
    @country_salary_gender_table = CensusData.country_salary_gender_table
    @count = @country_salary_gender_table.length - 1
  end
end

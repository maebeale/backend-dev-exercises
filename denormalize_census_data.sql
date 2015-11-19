--  this script can be called from the command line via the following:
--  $ sqlite3 -header -csv exercise01.sqlite < denormalize_census_data.sql > ./censusaur/db/import_data/denormalized_census_data_1996.csv

SELECT records.*,
       countries.name AS country,
       education_levels.name AS education_level,
       marital_statuses.name AS marital_status,
       occupations.name AS occupation,
       races.name AS race,
       relationships.name AS relationship,
       sexes.name AS sex,
       workclasses.name AS workclass
FROM   countries, education_levels, marital_statuses,
       occupations, races, records, relationships, sexes, workclasses
WHERE  records.country_id = countries.id AND
       records.education_level_id = education_levels.id AND
       records.marital_status_id = marital_statuses.id AND
       records.occupation_id = occupations.id AND
       records.race_id = races.id AND
       records.relationship_id = relationships.id AND
       records.sex_id = sexes.id AND
       records.workclass_id = workclasses.id;

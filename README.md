## RTI CDS Backend Developer Exercise 01 (annotated)

Thank you for the opportunity to complete Exercise 01.

Notes re each task are below. I look forward to meeting with you!

----

### The Task

0. Read the section below about **The Data**.
  - Thanks for the explicit explanation of each field!

1. Write a SQL query that creates a consolidated dataset from the normalized tables in the database.
  - SQL Query: ``denormalize_census_data.sql``
  - Pursued a dynamic SQL option (via ``sqlite_master`` or ``PRAGMA table_info``) to take any number of columns,
  provided they followed the naming convention and had a matched (pluralized) table in the same db.
  Wasn't able to find, but this was fun to consider!

2. Export the "flattened" table to a CSV file.
  - Completed via the command line: ``$ sqlite3 -header -csv exercise01.sqlite < denormalize_census_data.sql > ./censusaur/db/import_data/denormalized_census_data_1996.csv``
  - Pursued automating the above using a Ruby file to call a series of sqlite3 dot commands via the command line, but preliminary searches indicate that's not possible.

# NOTE: commands and files mentioned below are within the Rails project, Censusaur

3. Import the "flattened" table (or CSV file) and put it into a data structure for analysis.
  - Imported into Postgres using Ruby (using this import file ``censusaur/db/census_data_import.rb``).
    - Postgres has much better documentation and querying interfaces than those found for SQLite3.
    - Given the temporary nature of this app, to avoid secrets, environment variables, etc, the database username was set to ``maebeale`` in the database.yml
  - Database can (almost!) be set up via: ``$ rake db:rebuild_with_csv_data``. This does NOT import the csv...
    - Import was first done using ActiveRecord, but was too slow, so switched to SQL insert statements
    - Records are imported in batches (no jobs were created, but it still seemed helpful to the system to have breakpoints, and also provided the opportunity to (manually) test the import and charts against a small dataset.)
    - The (not idempotent) importer can be independently run via its own rake task:  ``$ rake db:import_census_data[100,500]``
      - The import_census_data rake task takes two arguments: number of rows per batch, and number of batches (optional)
      - The final 42 records are not being imported.
  - Got ipython notebook installed (along w python, etc -- first via homebrew, and then via anaconda), thinking it'd be an appropriate "data structure for analysis," but then doubled-back to Ruby on Rails given familiarity and time constraints.

4. Perform some simple exploratory analysis and generate summary statistics to get a sense of what is in the data.
  - Used pgAdminIII to perform simple queries.
  - Some findings:
    - Americans largely are native to the U.S. -- approximately 90%. The next highest native country (Mexico) represents only 2% of the population.
    - Men in the United States are more than 5 times more likely to make more than 50k/year than their female counterparts.
    - Most adults in the U.S. are employed in the private sector, with men making up the majority of the quantity and diversity of the workforce. Almost no one has worked without pay or never worked, though a segment of the population whose employment data remains unknown could reveal higher numbers with negligible work history.
    - The American private sector is predominately white.
  - Potential questions:
    - Do people who earn less work more hours, or do the extra hours move people over 50k mark?
    - Can one's maximum education level predict average number of hours worked per week as an adult?
    - In which fields is a master's degree required to make more than 50k/year?
    - Do smaller subsets of the population (e.g. Amer Indian Eskimo, people native to another country), tend to have more similar relationship and employment situations?
    - Does higher education offer women more employment opportunities and/or earning potential than for men in the U.S.?
    - Which groups tend to have capital losses?
    - And plenty more!

5. Create a simple web application that shows your analysis.
  - Created a simple, two-page app to show (formatted) imported data and a few simplistic charts

6. Create a paginated view of the data in your web application.
  - Gems used: 'twitter-bootstrap-rails', 'will_paginate-bootstrap'
  - Tried to show charts below the table to draw only from paginated data.

7. Generate one or more charts that you feel convey important relationships in the data.
  - Gem used: 'chartkick', and a [Google Combo Chart](https://developers.google.com/chart/interactive/docs/gallery/combochart)
  - Without experience in data analytics or data vizualization, multiple series analysis/charts were a stretch. Found some [awesome examples](http://individual.utoronto.ca/zabet/census-income.html) out there, but given time constraints was not able to reproduce.
  - Data for the Google chart was handrolled -- this absolutely could be done more programmatically!

----

### The Data

- Questions:
  - Given that some fields were designated continuous variables, but the dataset only included discrete values, should I have used the float datatype?
  - My first instinct was to strip out the "?" values, but are those left in (or inserted) when data warehousing to avoid issues related to null values?

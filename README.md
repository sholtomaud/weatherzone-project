# weatherzone-project

## Assumptions

1. You have a MYSQL system is setup using the create_table_forecasts.sql
2. Has a **test** db accessible from localhost without a password

## Setup

Clone into a development directory with ```git clone https://github.com/shotlom/weatherzone-project.git```

## Run

To run the script you must be in the weatherzone-project directory created by git.

```perl

  cd weatherzone-project
  perl ./test.pl

```
## Additional Notes

* The forecast data appears to be the same, but in different file types.
* This means, combined with ```UNIQUE KEY idx_forecasts_1 ( loc_type, loc_code, forecast_date )``` means that you cannot uniquify records per system and you will get duplicates, which are ignored (not imported)
* Variables like prob_precip are lost from the source data (not imported)

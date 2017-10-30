# weatherzone-project

## Assumptions

1. You have a MYSQL system which is setup using the create_table_forecasts.sql script
2. The MYSQL db has a **test** db accessible from localhost without a password
3. You have Git & Perl installed
4. You have cpanm installed

cpanm can be installed with:

```bash

curl -L https://cpanmin.us | perl - --sudo App::cpanminus

```

## Setup

Clone into a development directory with:

```bash

git clone https://github.com/shotlom/weatherzone-project.git

```

Install dependencies (cpanm may require sudo):

```bash

cd weatherzone-project
cpanm --installdeps .

```

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

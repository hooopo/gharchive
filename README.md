# GH Archive for TiDB

## Usage

* set DATABASE_URL env in .env.local
* bundle exec rails db:create
* bundle exec rails db:migrate
* bundle exec rake gh:import

```txt
Start import gharchive event data from 2015-01-01 to 2021-11-19 ...
start downloading, cache get, use /Users/hooopo/w/ping/gharchive/cache/gharchives/2015-01-01-0.json.gz
start parse json data ...
start insert into DB ...
```

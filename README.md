# GH Archive for TiDB

## Usage

* set DATABASE_URL env in .env.local
* bundle exec rails db:create
* bundle exec rails db:migrate
* bundle exec rake gh:import

env config

```
FROM=2016-01-01 TO=2017-12-31 DUMP_DIR=/tmp/gh CACHE_DIR=/tmp/cache bundle exec rake gh:import
```

```txt
Start import gharchive event data from 2015-01-01 to 2021-11-22 ...
start downloading, cache miss, request url: http://data.gharchive.org/2015-01-01-0.json.gz
start parse json data ...
start dump 7702 records to csv file ...
Start import gharchive event data from 2015-01-01 to 2021-11-22 ...
start downloading, cache miss, request url: http://data.gharchive.org/2015-01-01-1.json.gz
start parse json data ...
start dump 7427 records to csv file ...
Start import gharchive event data from 2015-01-01 to 2021-11-22 ...
start downloading, cache miss, request url: http://data.gharchive.org/2015-01-01-2.json.gz
start parse json data ...
start dump 6743 records to csv file ...
Start import gharchive event data from 2015-01-01 to 2021-11-22 ...
start downloading, cache miss, request url: http://data.gharchive.org/2015-01-01-3.json.gz
start parse json data ...
start dump 5971 records to csv file ...
Start import gharchive event data from 2015-01-01 to 2021-11-22 ...
start downloading, cache miss, request url: http://data.gharchive.org/2015-01-01-4.json.gz
start parse json data ...
start dump 5869 records to csv file ...
Start import gharchive event data from 2015-01-01 to 2021-11-22 ...
start downloading, cache miss, request url: http://data.gharchive.org/2015-01-01-5.json.gz
start parse json data ...
start dump 5887 records to csv file ...
Start import gharchive event data from 2015-01-01 to 2021-11-22 ...
start downloading, cache miss, request url: http://data.gharchive.org/2015-01-01-6.json.gz
start parse json data ...
start dump 8322 records to csv file ...
Start import gharchive event data from 2015-01-01 to 2021-11-22 ...
start downloading, cache miss, request url: http://data.gharchive.org/2015-01-01-7.json.gz
start parse json data ...
start dump 7105 records to csv file ...
```

**dumping files**

```txt
gharchive_dev-schema-create.sql            gharchive_dev.github_events.000000010.csv
gharchive_dev.github_events-schema.sql     gharchive_dev.github_events.000000011.csv
gharchive_dev.github_events.000000001.csv  gharchive_dev.github_events.000000012.csv
gharchive_dev.github_events.000000002.csv  gharchive_dev.github_events.000000013.csv
gharchive_dev.github_events.000000003.csv  gharchive_dev.github_events.000000014.csv
gharchive_dev.github_events.000000004.csv  gharchive_dev.github_events.000000015.csv
gharchive_dev.github_events.000000005.csv  gharchive_dev.github_events.000000016.csv
gharchive_dev.github_events.000000006.csv  gharchive_dev.github_events.000000017.csv
gharchive_dev.github_events.000000007.csv  gharchive_dev.github_events.000000018.csv
gharchive_dev.github_events.000000008.csv  gharchive_dev.github_events.000000019.csv
gharchive_dev.github_events.000000009.csv
```

**import to TiDB cluster using tidb-lightning**

```
/home/ubuntu/.tiup/components/tidb-lightning/v5.2.2/tidb-lightning -config ./tidb-lightning.toml
Verbose debug logs will be written to /tmp/lightning.log.2021-11-22T07.43.16Z

+---+----------------------------------------------+-------------+--------+
| # | CHECK ITEM                                   | TYPE        | PASSED |
+---+----------------------------------------------+-------------+--------+
| 1 | Source csv files size is proper              | performance | true   |
+---+----------------------------------------------+-------------+--------+
| 2 | checkpoints are valid                        | critical    | true   |
+---+----------------------------------------------+-------------+--------+
| 3 | table schemas are valid                      | critical    | true   |
+---+----------------------------------------------+-------------+--------+
| 4 | Cluster is available                         | critical    | true   |
+---+----------------------------------------------+-------------+--------+
| 5 | Lightning has the correct storage permission | critical    | true   |
+---+----------------------------------------------+-------------+--------+
tidb lightning exit
```

## Dependency 

### TiUP

```
curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh
```

### tidb-lightning

```

tiup install tidb-lightning
```
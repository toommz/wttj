# WTTJ

Technical test for WTTJ.

## Data

In `db/continents` we can find `GeoJSON` data representing (approximately for performance sakes) the shapes of our continents. [Raw source from this SO post](https://stackoverflow.com/questions/13905646/get-the-continent-given-the-latitude-and-longitude)

## Exercice 1

**How to run?**

```bash
./wttj
```

Sample output:

```bash
+---------------+-------+-------+----------+---------+------+-------------------+--------+------+
|               | Total | Admin | Business | Conseil | Créa | Marketing / Comm' | Retail | Tech |
+---------------+-------+-------+----------+---------+------+-------------------+--------+------+
| Total         | 5069  | 411   | 1445     | 175     | 212  | 782               | 536    | 1439 |
| Africa        | 9     | 1     | 3        | 0       | 0    | 1                 | 1      | 3    |
| Asia          | 51    | 1     | 30       | 0       | 0    | 3                 | 6      | 11   |
| Australia     | 1     | 0     | 0        | 0       | 0    | 0                 | 1      | 0    |
| Europe        | 4735  | 396   | 1372     | 175     | 205  | 759               | 426    | 1402 |
| North America | 156   | 9     | 27       | 0       | 7    | 12                | 87     | 14   |
| South America | 5     | 0     | 4        | 0       | 0    | 0                 | 0      | 1    |
+---------------+-------+-------+----------+---------+------+-------------------+--------+------+
```

**What could have been done better**

- The `WTTJ.CLI` could have been more readable if I had more time left for this first exercise.
- Some parts are not so much idiomatic `elixir` I think
- and surely other things that I didn't notice

## Exercice 2 (questions)

To handle scaling issues without re-architecturing data, we could:

- launch the script as a persistent process
- add a watcher on the CSV files using OS system calls (ie: inotify())
- update the data used to return statistics (computed maps returned by the `WTTJ` and `WTTJ.Statistics` modules)
- use concurrent workers (using `Task` module for example)

If we can re-architecture data, we could:

- use a RDBMS as the data storage and stop using flat files
- let the storage layer handle consistency between relations (link jobs and professions, professions and categories)
- place the right indexes in database to provide good performance for the usual requests made to produce the wanted statistics
- use GIS extensions in database to speed up mapping latitudes/longitudes tuples to continents

## Exercise 3

I must admit that I am not 100% sure about the scope of this part, so here is what I have done:

- continued to use flat files for data (I could have imported it in a RDBMS)
- added a web server dependency (Cowboy using `plug_cowboy`)
- added an endpoint on the `/jobs` route responding with jobs serialized in `JSON`
- implemented two filters (on `name` and `profession_id`) within a common base on which I could have added more filters

**What could have been implemented**

- more filters
  - pass a location and a distance, find jobs nearby
  - accept a profession category name
  - let filter by contract type
- pagination

**How to use it?**

```bash
iex -S mix

curl http://localhost:3000/jobs?name=ingénieur
```

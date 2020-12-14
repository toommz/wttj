# WTTJ

Technical test for WTTJ.

## Data

In `db/continents` we can find `GeoJSON` data representing (approximately for performance sakes) the shapes of our continents. [Raw source from this SO post](https://stackoverflow.com/questions/13905646/get-the-continent-given-the-latitude-and-longitude)

## Exercice 1

How to run?

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

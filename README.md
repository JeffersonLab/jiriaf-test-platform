# Run Tests by Helm Chart
Steps to run tests by Helm chart.
1. Define the ID of the test record. For example, `ID=ersap-test`. This ID will be used for Helm chart name.
2. Run [`helm install ID prom/ --set Deployment.name=ID](main/job/prom). This will create prometheus instance in the cluster for the test.


# Test Record

| ID | Helm chart | ersap version | num pipes | time period                                | compute site | pipes started at the same time | test goal | result                        |
|----|------------|---------------|-----------|-------------------------------------------|--------------|--------------------------------|------------|-------------------------------|
| 0  | ersap-test | v0.1          | 6         | 2024-05-31 03:35:40 to 04:24:19 UTC       | ejfat        | Y                              | init test  |                               |
| 1  | ersap-test2 | v0.2         | 6         | 2024-06-01 00:57:00 to 02:01:37 UTC       | ejfat        | Y                              | check if all pipes will survive after 15 mins. | no |
| 2  | ersap-test3 | v0.1         | 3         | 2024-06-01 03:40:16 to 04:55:09 UTC       | ejfat        | N                              | intermittent start of pipes, checking if pipes will survive. | One pipe survives at a time |
| 3  | ersap-test4 | v0.2         |           |                                           |              |                                | using v0.2 for the test on row 2. | |
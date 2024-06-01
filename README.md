# Branches used for testing

| Test platform | vk-cmd | J-process-exporter |
| :------------ | :----- | :----------------- |
| test-ersap    | main   | pgid               |

# Docker images used for testing

| Test platform | vk-cmd | J-process-exporter |
| :------------ | :----- | :----------------- |
| test-ersap-wf | main   | pgid-go            |


# Description of files for the tests
All the tests located in the `main` directory.

| File name | Description |
| :-------- | :---------- |
| anomaly-main/run-this-first.yaml | Run this file first to create bash scripts for getting pgid of the ERSAP wf container and for running the J-process-exporter |
| anomaly-main/ersap.yml | Create ERSAP wf docker container |
| anomaly-main/stress-docker.yaml | Create stress docker container |
| anomaly-main/kill.yaml | Kill container and its processes |
| - | - |
| start-ejfat/ssh.sh | Important commands for creating ssh tunnels for monitoring ERSAP (running from local) |
| start-ejfat/monitor.sh | Some useful commands for monitoring |

# Test Record

| ID | Helm chart | ersap version | num pipes | time period                                | compute site | pipes started at the same time | test goal | result                        |
|----|------------|---------------|-----------|-------------------------------------------|--------------|--------------------------------|------------|-------------------------------|
| 0  | ersap-test | v0.1          | 6         | 2024-05-31 03:35:40 to 04:24:19 UTC       | ejfat        | Y                              | init test  |                               |
| 1  | ersap-test2 | v0.2         | 6         | 2024-06-01 00:57:00 to 02:01:37 UTC       | ejfat        | Y                              | check if all pipes will survive after 15 mins. | no |
| 2  | ersap-test3 | v0.1         | 3         | 2024-06-01 03:40:16 to 04:55:09 UTC       | ejfat        | N                              | intermittent start of pipes, checking if pipes will survive. | One pipe survives at a time |
| 3  | ersap-test4 | v0.2         |           |                                           |              |                                | using v0.2 for the test on row 2. | |

# monicron
Lightweight crontab change detection tool

A detailed explanation is provided in https://medium.com/@hkarakose/keep-your-cron-entries-safe-37fd33b2667e.

#### Configuration

Update `TO_EMAIL` in monicron.sh

Update `FROM_EMAIL` in monicron.sh 

#### Usage
The project contains an initialization script which adds monicro.sh to crontab. Execute the script to initialize the project.

    chmod +x *
    ./init_cron.sh

You can review execution using monicron.log

    tail -f monicron.log

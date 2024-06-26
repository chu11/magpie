#!/bin/bash

source test-generate-common.sh
source test-config.sh
source test-generate-spark-helper.sh
source test-generate-zookeeper-helper.sh

GenerateDefaultStandardTests() {

    cd ${MAGPIE_SCRIPTS_HOME}/testsuite/

    echo "Making Default Standard Tests"

# Default Tests

    if [ "${hadooptests}" == "y" ]; then
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-hadoop magpie.${submissiontype}-hadoop-default-run-hadoopterasort
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-hadoop magpie.${submissiontype}-hadoop-default-run-hadoopterasort-no-local-dir
    fi
    if [ "${pigtests}" == "y" ]; then
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-hadoop-and-pig magpie.${submissiontype}-hadoop-and-pig-default-run-testpig
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-hadoop-and-pig magpie.${submissiontype}-hadoop-and-pig-default-run-testpig-no-local-dir
    fi
    if [ "${hbasetests}" == "y" ]; then
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-hbase-with-hdfs magpie.${submissiontype}-hbase-with-hdfs-default-run-hbaseperformanceeval
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-hbase-with-hdfs magpie.${submissiontype}-hbase-with-hdfs-default-run-hbaseperformanceeval-no-local-dir
    fi
    if [ "${hivetests}" == "y" ]; then 
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-hadoop-and-hive magpie.${submissiontype}-hadoop-and-hive-default-run-testbench
    fi
    if [ "${phoenixtests}" == "y" ]; then
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-hbase-with-hdfs-with-phoenix magpie.${submissiontype}-hbase-with-hdfs-with-phoenix-default-run-phoenixperformanceeval
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-hbase-with-hdfs-with-phoenix magpie.${submissiontype}-hbase-with-hdfs-with-phoenix-default-run-phoenixperformanceeval-no-local-dir
    fi
    if [ "${sparktests}" == "y" ]; then
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-spark magpie.${submissiontype}-spark-default-run-sparkpi
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-spark magpie.${submissiontype}-spark-default-run-sparkpi-no-local-dir
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-spark-with-hdfs magpie.${submissiontype}-spark-with-hdfs-default-run-sparkwordcount-copy-in
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-spark-with-hdfs magpie.${submissiontype}-spark-with-hdfs-default-run-sparkwordcount-copy-in-no-local-dir
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-spark-with-yarn magpie.${submissiontype}-spark-with-yarn-default-run-sparkwordcount-copy-in
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-spark-with-yarn magpie.${submissiontype}-spark-with-yarn-default-run-sparkwordcount-copy-in-no-local-dir
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-spark-with-yarn-and-hdfs magpie.${submissiontype}-spark-with-yarn-and-hdfs-default-run-sparkwordcount-copy-in
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-spark-with-yarn-and-hdfs magpie.${submissiontype}-spark-with-yarn-and-hdfs-default-run-sparkwordcount-copy-in-no-local-dir

        SetupSparkWordCountHDFSCopyIn `ls \
            magpie.${submissiontype}-spark-with-hdfs-default-run-sparkwordcount-copy-in* \
            magpie.${submissiontype}-spark-with-yarn-and-hdfs-default-run-sparkwordcount-copy-in*`

        SetupSparkWordCountRawNetworkFSNoCopy `ls \
            magpie.${submissiontype}-spark-with-yarn-default-run-sparkwordcount-copy-in*`
    fi
    if [ "${stormtests}" == "y" ]; then
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-storm magpie.${submissiontype}-storm-default-run-stormwordcount
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-storm magpie.${submissiontype}-storm-default-run-stormwordcount-no-local-dir
    fi
    if [ "${zookeepertests}" == "y" ]; then
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-storm magpie.${submissiontype}-zookeeper-default-run-zookeeperruok
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-storm magpie.${submissiontype}-zookeeper-default-run-zookeeperruok-no-local-dir

        SetupZookeeperFromStorm `ls \
            magpie.${submissiontype}-zookeeper-default-run-zookeeperruok*`
    fi
    if [ "${zeppelintests}" == "y" ]; then
        cp ../submission-scripts/script-${submissiontype}/magpie.${submissiontype}-spark-with-zeppelin magpie.${submissiontype}-spark-with-zeppelin-default-run-checkzeppelinup
    fi
}

GenerateDefaultStandardPostProcessing () {
    # We know Hadoop 3.X is default now
    files=`find . -maxdepth 1 -name "magpie.${submissiontype}-hadoop-default-run-hadoopterasort*"`
    if [ -n "${files}" ] && [ -x "/usr/bin/pdsh" ]
    then
        sed -i -e "s/FILENAMESEARCHREPLACEKEY/pdshlaunch-FILENAMESEARCHREPLACEKEY/" ${files}
    fi

    # Starting with Spark 3.4 only Hadoop3+ is supported, so pdshlaunch is assumed if
    # anything hadoop is done
    files=`find . -maxdepth 1 -name "magpie.${submissiontype}-spark-with*default*"`
    if [ -n "${files}" ] && [ -x "/usr/bin/pdsh" ]
    then
        for file in ${files}
        do
            if grep SPARK_VERSION ${file} | grep -q -E "3\.[4-9]\.[0-9]"
            then
                sed -i -e "s/FILENAMESEARCHREPLACEKEY/pdshlaunch-FILENAMESEARCHREPLACEKEY/" ${file}
            fi
        done
    fi
}

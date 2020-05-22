# Hive Setup

The Apache Hive ™ data warehouse software facilitates reading, writing, and managing large datasets residing in distributed storage using SQL. Structure can be projected onto data already in storage. A command line tool and JDBC driver are provided to connect users to Hive.

![alt-txt](https://hive.apache.org/images/hive_logo_medium.jpg)

## Single Node Setup

Just follow the simple steps to setup Hive.

Assigne executable rights by:

```bash
chmod a+x singlenode-hadoop.sh
chmod a+x hive.sh
```

Step 2: Execute the script

```bash
sudo bash singlenode-hadoop.sh
sudo bash hive.sh
```

## Edit .bashrc (hduser)

```bash
# Set HIVE_HOME

export HIVE_HOME=/usr/local/apache-hive-3.1.2-bin
export PATH=$PATH:/usr/local/apache-hive-3.1.2-bin/bin

# Set Hadoop-related environment variables

export HADOOP_HOME=/usr/local/hadoop-3.2.1
export HADOOP_CONF_DIR=/usr/local/hadoop-3.2.1/etc/hadoop
export HADOOP_MAPRED_HOME=/usr/local/hadoop-3.2.1
export HADOOP_COMMON_HOME=/usr/local/hadoop-3.2.1
export HADOOP_HDFS_HOME=/usr/local/hadoop-3.2.1
export YARN_HOME=/usr/local/hadoop-3.2.1
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

# Set JAVA_HOME

export JAVA_HOME=/usr/lib/jvm/default-java
export PATH=$PATH:/usr/lib/jvm/default-java/bin

# Add Hadoop bin/directory to PATH

export PATH=$PATH:/usr/local/hadoop-3.2.1/bin
export HADOOP_PID_DIR=/usr/local/hadoop-3.2.1/hadoop2_data/hdfs/pid
```

## Authors

* **Prashant Piprotar** - - [Prash+](https://github.com/prashplus)

Visit my blog for more Tech Stuff
### http://www.prashplus.com
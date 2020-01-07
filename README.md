# Postgap via Docker

Installing and running [postgap](https://github.com/Ensembl/postgap) per the project instructions does not currently work given that many of the python dependencies are not pinned and have since deprecated python 2.7 support (which postgap needs).  This project contains an Ubuntu 16.04 build (loosely based on [willmclaren/postgap](https://hub.docker.com/r/willmclaren/postgap/)) with pinned dependencies that should work regardless of further development in underlying dependencies.  

## Build and Execution

To build:

```bash
cd $REPOS/postgap-docker
docker build -t postgap .
```

To run:

```bash
export DATA_DIR=/data/disk1/dev
docker run --rm -ti \
-v $DATA_DIR:/home/postgap/data \
postgap
```

To initialize downloads:

```
# On host:
mkdir -p $DATA_DIR/ensembl/postgap/downloads
chmod 777 $DATA_DIR/ensembl/postgap/downloads

# On container:
cd /home/postgap/data/ensembl/postgap/downloads
# Should take about ~1hr with ~50Mb down bandwidth (17G in total)
sh ~/src/postgap/scripts/installation/download.sh
```

To test postgap:

```
# On container:

# Simple example (takes ~1 hr)
python POSTGAP.py --disease autism --debug \
--database_dir=/home/postgap/data/ensembl/postgap/downloads/databases \
--output output/autism.tsv

# Using stats export from https://www.ebi.ac.uk/gwas/studies/GCST007400
# (takes ~5 hrs!)
# Also, needed https://github.com/Ensembl/postgap/issues/157 to get this to run
python POSTGAP.py --debug \
--database_dir=/home/postgap/data/ensembl/postgap/downloads/databases \
--summary_stats=/home/postgap/data/ensembl/postgap/input/postgap_GCST007400.tsv \
--output output/test_GCST007400_1.tsv
```

## Notebooks

The [notebooks](notebooks) show examples of:
1. What happens to outputs when you run postgap with the same inputs
2. How to generate postgap-compatible inputs from GWAS catalog exports

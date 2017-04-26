#!/bin/sh

set -e

DATE_QUERY=$(date '+%Y-%m-%d %H:%M:%S')
DATE_WEEK=$(date '+%Y-%W')

REPORT_DIR='/opt/noobmon/reports'
mkdir -p ${REPORT_DIR}

REPORT_GPU="${REPORT_DIR}/gpu-${DATE_WEEK}.csv"
if [ ! -e ${REPORT_GPU} ]
then
    echo 'time,gpu1,gpu2,gpu3,gpu4,gpu5,gpu6,gpu7,gpu8' > ${REPORT_GPU}
fi

echo -n "${DATE_QUERY}," >> ${REPORT_GPU}
echo $(nvidia-smi --query-gpu=utilization.gpu --format=csv,nounits,noheader | tr '\n' ',') >> ${REPORT_GPU}

REPORT_CPU="${REPORT_DIR}/cpu-${DATE_WEEK}.csv"
if [ ! -e ${REPORT_CPU} ]
then
    echo 'time,cpu' > ${REPORT_CPU}
fi

echo -n "${DATE_QUERY}," >> ${REPORT_CPU}
echo $(mpstat 1 1 | tail -n 1 | awk -v x=12 '{print 100-$x}') >> ${REPORT_CPU}

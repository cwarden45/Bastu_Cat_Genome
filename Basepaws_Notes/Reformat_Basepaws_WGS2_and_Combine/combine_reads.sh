#!/bin/bash

R1I1=AB.CN.45.31211051000777.LP.858.D9.L1.R186.WGS_R1.fastq.gz
R1I2=AB.CN.45.31211051000777.SP.319.D1.L2.R186.WGS_R1.fastq.gz
R1I3=AB.CN.45.31211051000777.SP.329.E1.L2.R195.WGS_R1.fastq.gz
R1O=Basepaws_WGS2_R1.fastq.gz

cat $R1I1 $R1I2 $R1I3 > $R1O

R2I1=AB.CN.45.31211051000777.LP.858.D9.L1.R186.WGS_R2.fastq.gz
R2I2=AB.CN.45.31211051000777.SP.319.D1.L2.R186.WGS_R2.fastq.gz
R2I3=AB.CN.45.31211051000777.SP.329.E1.L2.R195.WGS_R2.fastq.gz
R2O=Basepaws_WGS2_R2.fastq.gz

cat $R2I1 $R2I2 $R2I3 > $R2O
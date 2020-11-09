Get sample coverages from illumina and nanopore reads.

To run the sample test:
```
python get_samples_coverage.py --samples_csv samples.csv
diff -qs read_coverages.csv read_coverages.sample_output.csv
```

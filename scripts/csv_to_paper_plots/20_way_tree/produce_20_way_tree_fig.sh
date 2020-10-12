# Parsnp v1.5.3
# Harvesttools v1.2
# Gubbins v2.4.1

parsnp -r ! -d 44_tree_20200925/ -o parsnp_44_refs -c -n mafft -p 4 

cd parsnp_44_refs/

harvesttools -x parsnp.xmfa -M 44_refs.mfa

run_gubbins.py --prefix 44_refs --threads 4 --raxml_model GTRGAMMA 44_refs.mfa

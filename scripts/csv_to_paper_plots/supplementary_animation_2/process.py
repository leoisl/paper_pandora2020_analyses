import os
import imageio

plots = []
for nb_of_samples in range(2, 21):
    plot = f"recall_per_ref_per_nb_of_samples_per_clade.snippy_pandora.nb_of_samples_{nb_of_samples}.png"
    plots.append(plot)
    os.system(f"Rscript clade_plots.R recall_per_ref_per_nb_of_samples_per_clade.snippy_pandora.nb_of_samples_{nb_of_samples}.simplified.csv 0 {nb_of_samples} {plot}")

# generate the gif
images = [imageio.imread(plot) for plot in plots]
imageio.mimsave(f"recall_per_ref_per_nb_of_samples_per_clade.snippy_pandora.gif", images, duration=2)

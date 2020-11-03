# If you want to use this container, it is simpler to just pull it:
#   docker pull leandroishilima/pandora1_paper_full_pipeline_r_container:pandora_paper_tag1

# This container has R and the libraries needed to build plots in this repo
# to build: sudo docker build . -t leandroishilima/pandora1_paper_full_pipeline_r_container:pandora_paper_tag1
FROM rocker/r-base:4.0.3

# install basic tools
RUN apt-get update
RUN apt-get install -y wget python3.8 python3-pip python3-dev libcurl4-openssl-dev libssl-dev libxml2-dev
RUN cp /usr/bin/python3.8 /usr/bin/python
RUN cp /usr/bin/pip3 /usr/bin/pip

# install python requirements
ADD ./requirements.txt .
RUN pip install -r requirements.txt

# install R requirements
ARG extra_packages="c(\"gridExtra\", \"ggplot2\", \"data.table\", \"devtools\", \"png\", \"assertr\", \"tidyverse\", \"ggnewscale\", \"pheatmap\", \"reshape\", \"reshape2\", \"tidyr\")"
RUN echo "install.packages($extra_packages, repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "devtools::install_github('cttobin/ggthemr')" | R --no-save

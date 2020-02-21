FROM ubuntu:18.04
MAINTAINER Alise Ponsero <aponsero@email.arizona.edu>
LABEL Description "This Dockerfile is for MARVEL-0.2"

RUN apt-get update && apt-get install -y wget python3.7

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda config --add channels conda-forge 
RUN conda config --add channels defaults 
RUN conda config --add channels bioconda
RUN conda install -y prokka hmmer numpy scipy biopython scikit-learn 

COPY MARVEL/ /usr/bin
RUN chmod +x  /usr/bin/download_and_set_models.py
RUN chmod +x /usr/bin/generate_bins_from_reads.py
RUN python3 /usr/bin/download_and_set_models.py

CMD [ "/usr/bin/generate_bins_from_reads.py" ]

FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh
ENV PATH=$CONDA_DIR/bin:$PATH

# Create conda environment
RUN conda create -n llm-foundry python=3.12 uv cuda -c nvidia/label/12.4.1 -c conda-forge && \
    echo "conda activate llm-foundry" >> ~/.bashrc

# Set up environment variables
ENV CONDA_DEFAULT_ENV=llm-foundry
ENV CONDA_PREFIX=/opt/conda/envs/llm-foundry
ENV PATH=/opt/conda/envs/llm-foundry/bin:$PATH
ENV UV_PROJECT_ENVIRONMENT=$CONDA_PREFIX

# Clone repository and install dependencies
WORKDIR /app
RUN git clone https://github.com/LocalResearchGroup/llm-foundry.git && \
    cd llm-foundry && \
    uv python pin 3.12 && \
    uv sync --extra dev --extra gpu && \
    uv sync --extra dev --extra gpu --extra flash

# Install JupyterLab
RUN pip install jupyterlab

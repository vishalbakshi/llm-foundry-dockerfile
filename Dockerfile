FROM mosaicml/llm-foundry:release-latest

# Create symlink for python3 to composer-python
RUN ln -sf /composer-python/python /usr/bin/python && \
    ln -sf /composer-python/python3 /usr/bin/python3

# Install Jupyter
RUN pip install jupyterlab
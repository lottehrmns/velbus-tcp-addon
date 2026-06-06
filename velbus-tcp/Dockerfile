ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install python-velbustcp directly from GitHub (not published on PyPI)
RUN pip3 install --no-cache-dir \
    git+https://github.com/velbus/python-velbustcp.git

# Copy the startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]

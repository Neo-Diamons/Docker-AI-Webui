FROM python:3.10.6-slim-bullseye

# Install the required packages
RUN apt-get update
RUN apt-get install -y \
    wget \
    git \
    libgl1 \
    libglib2.0-0 \
    google-perftools \
    bc \
    procps \
    vim

# Set TCMalloc as the default allocator
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4"

# Create a user to run the webui without root-privileges
RUN useradd -m myuser
USER myuser
WORKDIR /home/myuser
ENV PATH="/home/myuser/.local/bin:${PATH}"

# Download the webui
RUN git clone --depth 1 --branch v1.10.0 https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

# Create necessary directories and set permissions
RUN mkdir -p /home/myuser/stable-diffusion-webui/repositories
RUN mkdir -p /home/myuser/stable-diffusion-webui/extensions
RUN chown -R myuser:myuser /home/myuser/stable-diffusion-webui

# Install the required python packages
WORKDIR /home/myuser/stable-diffusion-webui
RUN pip install -r requirements.txt
RUN pip install xformers

# Create the extensions directory
RUN mkdir -p stable-diffusion-webui/extensions
WORKDIR /home/myuser/stable-diffusion-webui/extensions

# Install default extensions
RUN git clone "https://github.com/lobehub/sd-webui-lobe-theme" lobe-theme
RUN git clone "https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git" tagcomplete
RUN git clone "https://github.com/BlafKing/sd-civitai-browser-plus.git" civitai-browser-plus
RUN git clone "https://github.com/AlUlkesh/stable-diffusion-webui-images-browser.git" images-browser

# Copy the custom webui.sh script and set permissions
WORKDIR /home/myuser/stable-diffusion-webui
COPY ./webui.sh .
USER root
RUN chown myuser:myuser webui.sh && \
    chmod +x webui.sh
USER myuser

# Start the webui with API enabled, listening on all interfaces and allowing insecure extension access
CMD ["./webui.sh", \
    "--api", \
    "--listen", \
    "--enable-insecure-extension-access", \
    "--xformers" \
]

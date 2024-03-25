FROM python:3.10-slim-bullseye

# Install the required packages
RUN apt-get update && apt-get install -y \
    wget \
    git \
    libgl1 \
    libglib2.0-0 \
    google-perftools \
    bc

# Create a user to run the webui without root-privileges
RUN useradd -m myuser
USER myuser
WORKDIR /home/myuser

# Download the webui
RUN wget -q "https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh" -O webui.sh
RUN chmod +x webui.sh
RUN ./webui.sh

# Create the extensions directory
RUN mkdir -p stable-diffusion-webui/extensions
WORKDIR /home/myuser/stable-diffusion-webui/extensions

# Install default extensions
RUN git clone "https://github.com/lobehub/sd-webui-lobe-theme" lobe-theme
RUN git clone "https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git" tagcomplete
RUN git clone "https://github.com/BlafKing/sd-civitai-browser-plus.git" civitai-browser-plus
RUN git clone "https://github.com/AlUlkesh/stable-diffusion-webui-images-browser.git" images-browser

# Create the models directory
RUN mkdir -p stable-diffusion-webui/models
WORKDIR /home/myuser/stable-diffusion-webui/models/Stable-diffusion

# Install the default model
RUN wget -q "https://civitai.com/api/download/models/119057?type=Model&format=SafeTensor&size=pruned&fp=fp16" -O MeinaMix.safetensors

# Move back to the user's home directory
WORKDIR /home/myuser

# Start the webui with API enabled, listening on all interfaces and allowing insecure extension access
CMD [ "/home/myuser/webui.sh", "--api", "--listen", "--enable-insecure-extension-access" ]

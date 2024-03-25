FROM ghcr.io/open-webui/open-webui:main

# Set default values
RUN sed -i 's/app.state.ENABLED = False/app.state.ENABLED = True/g' apps/images/main.py
RUN sed -i 's/app.state.IMAGE_STEPS = 50/app.state.IMAGE_STEPS = 20/g' apps/images/main.py

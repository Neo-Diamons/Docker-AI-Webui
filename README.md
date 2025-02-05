# Docker AI Webui

<img src="https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white" />

This repository contains a compose file to run the [Open-Webui](https://github.com/open-webui/open-webui) with [Ollama](https://github.com/ollama/ollama) and the [Stable-Diffusion-Webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui) with only one command.

The Open-Webui Dockerfile allow Image Generation per default with 512x512 resolution and 20 steps.

The Stable-Diffusion-Webui don't use the default UI and use instead the [Lobe Theme](https://github.com/lobehub/sd-webui-lobe-theme) and also install [a1111-sd-webui-tagcomplete](https://github.com/DominikDoom/a1111-sd-webui-tagcomplete), [sd-civitai-browser-plus](https://github.com/BlafKing/sd-civitai-browser-plus), [stable-diffusion-webui-images-browser](https://github.com/AlUlkesh/stable-diffusion-webui-images-browser) to improve user experience.

### Dependencies

- [Docker](https://docs.docker.com/get-docker/)

### Usage

```bash
docker compose up -d
```

### Access

- Open-Webui: [http://localhost:3000](http://localhost:3000)
- Stable-Diffusion-Webui: [http://localhost:7860](http://localhost:7860)
- Ollama: [http://localhost:11434](http://localhost:11434)

ARG NODE_VERSION=20
FROM n8nio/base:${NODE_VERSION}

# 1) Install runtime + build deps
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    su-exec \
    python3 \
    py3-pip \
    python3-dev \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    ffmpeg

# 2) Create a venv and install your Python libraries into it
ENV VENV_PATH=/opt/venv
RUN python3 -m venv $VENV_PATH \
 && $VENV_PATH/bin/pip install --upgrade pip \
 && $VENV_PATH/bin/pip install --no-cache-dir \
      matplotlib \
      PyPDF2 \
      openpyxl \
      python-docx \
      plotly \
      Pillow

# 3) Make the venv the default Python environment
ENV PATH="$VENV_PATH/bin:$PATH"

# Puppeteer env
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=false \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# 4) Install n8n + Puppeteer
RUN npm install -g puppeteer n8n \
 && npm cache clean --force

EXPOSE 5678

USER node
CMD ["n8n"]

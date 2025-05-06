ARG NODE_VERSION=20
FROM n8nio/base:${NODE_VERSION}

# Install Chromium and other runtime dependencies
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
  ffmpeg \
  gcc \
  musl-dev \
  libffi-dev \
  openssl-dev \
  python3-dev

# Install selected Python libraries
RUN pip3 install --no-cache-dir \
  matplotlib \
  PyPDF2 \
  openpyxl \
  python-docx \
  plotly \
  Pillow

# Puppeteer environment settings
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=false
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install Puppeteer and n8n
RUN npm install -g puppeteer n8n && \
  npm cache clean --force

EXPOSE 5678

USER node

CMD ["n8n"]

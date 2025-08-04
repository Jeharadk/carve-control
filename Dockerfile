# ---------- build stage ----------
FROM node:20-alpine AS builder
WORKDIR /app

# grab source
RUN apk add --no-cache git
RUN git clone --depth 1 https://github.com/GridSpace/carve-control .
RUN npm install --no-audit --no-fund
RUN npm run bundle

# ---------- runtime stage ----------
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app /app
# UI / WebSocket
EXPOSE 8001     

ENTRYPOINT ["node","lib/main.js"]
CMD ["autocon=1","proxy=1","web=1","webport=8001"]

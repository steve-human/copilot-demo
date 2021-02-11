# Stage 1 - Build App
FROM node:14-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . ./
RUN npm run build

# Stage 2: Start fresh, install a static server,
# and copy just the build artifacts from the previous stage.
FROM node:14-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
ENV PORT=3000
EXPOSE 3000
CMD ["node", "dist/main"]
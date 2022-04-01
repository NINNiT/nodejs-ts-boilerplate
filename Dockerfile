# Build Step
FROM node:16-alpine as builder

WORKDIR /app

COPY . .

RUN npm ci --ignore-scripts

RUN npm run build

# Runtime Step
FROM node:16-alpine as runtime

WORKDIR /app

COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/package-lock.json ./package-lock.json

COPY --from=builder /app/dist ./dist

RUN npm ci --production --ignore-scripts

CMD ["npm", "run", "start"]

FROM node:alpine

WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn

COPY server/ ./server

EXPOSE 8080

CMD ["node", "server/index.js"]

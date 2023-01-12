FROM node:16-alpine

WORKDIR /app

COPY package.json .
RUN npm install
COPY . .

EXPOSE 5005

CMD ["npm", "start"]
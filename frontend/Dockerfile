
FROM node:16-slim

WORKDIR /app/

COPY package.json package-lock.json /app/

RUN npm install --legacy-peer-deps

COPY . /app/

EXPOSE 3000
CMD ["npm", "start"]
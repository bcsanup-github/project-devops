FROM node:20-alpine

WORKDIR /app/

COPY package.json package-lock.json /app/
RUN npm install --legacy-peer-deps

COPY . /app/

EXPOSE 3000
CMD ["npm", "start"]
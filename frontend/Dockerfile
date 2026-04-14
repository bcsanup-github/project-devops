# Change from lts-slim to 16-slim to stop the postcss crash
FROM node:16-slim

WORKDIR /app/

COPY package.json package-lock.json /app/
# The legacy flag is key for older React projects
RUN npm install --legacy-peer-deps

COPY . /app/

EXPOSE 3000
CMD ["npm", "start"]
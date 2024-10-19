# Build environment
FROM node:18-alpine as builder  
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# Install dependencies
COPY package.json /usr/src/app/package.json
RUN npm install --silent
RUN npm install react-scripts@latest -g --silent  

# Copy the entire app and build
COPY . /usr/src/app
RUN npm run build

# Production environment
FROM nginx:alpine  
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


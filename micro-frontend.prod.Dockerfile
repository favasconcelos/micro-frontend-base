# build stage
FROM node:10.19.0-alpine as builder

ARG PROJECT_FOLDER_ARG

WORKDIR /app
COPY "$PROJECT_FOLDER_ARG/package.json" .
COPY "$PROJECT_FOLDER_ARG/yarn.lock" .
RUN yarn install
COPY $PROJECT_FOLDER_ARG .
RUN yarn build

# serve stage
FROM nginx:1.13.9-alpine

COPY nginx-apps.conf /etc/nginx/nginx.conf
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
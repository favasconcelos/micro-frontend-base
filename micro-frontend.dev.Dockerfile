# build stage
FROM node:10.15.3-alpine as builder

ARG PROJECT_FOLDER_ARG

WORKDIR /app
COPY "$PROJECT_FOLDER_ARG/package.json" .
COPY "$PROJECT_FOLDER_ARG/yarn.lock" .
RUN yarn install
COPY $PROJECT_FOLDER_ARG .
RUN yarn build

# serve stage
FROM node:10.15.3-alpine

RUN yarn global add serve

WORKDIR /app
COPY --from=builder /app/build .

EXPOSE 80
CMD ["serve", "--cors", "-p", "80", "-s", "."]

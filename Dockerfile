# ---------- Build App 1 ----------
# FROM node:lts-alpine3.22 AS build-site
# WORKDIR /site
# COPY site/ .
# RUN npm install && npm run build

# ---------- Build App 2 ----------
FROM node:lts-alpine3.22 AS build-recruiter
WORKDIR /recruiter
COPY recruiter/ .
RUN npm install && npm run build

# ---------- Nginx ----------
FROM nginx:alpine

# Remove default config
RUN rm -rf /etc/nginx/conf.d/*

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy builds
# COPY --from=build-site /site/build /usr/share/nginx/html/site
COPY --from=build-recruiter /recruiter/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
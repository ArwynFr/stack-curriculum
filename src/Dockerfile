FROM asciidoctor/docker-asciidoctor:1.88.0@sha256:bf13aec8dd2758eebd10a86cba611a88c5ccf8cfbf21ebe6af308397de204b63 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.8@sha256:1621604aeb5af3412534290cc701736e53de7390237ef21b6076123c0863d160 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.28.0-alpine-slim@sha256:8e4b7129bda901acd1ece5169d0fecad5b2c0b1fb6c8ee1a299edd8af45d4ae3 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./
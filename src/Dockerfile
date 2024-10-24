FROM asciidoctor/docker-asciidoctor:1.79.0@sha256:e2921ccf36e7a125675c92724ba604f84b3fe881205304921b5abf5256ccb87e AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.21.1@sha256:4471e23ff3e944f8d7ef7928763e8189dc56177e38fc7028fcd06344e246b6d3 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.2-alpine-slim@sha256:e209c27d52de5ef8996e94fab0f5fe7561f64d4000a8ab4883efdd32ae4ca8c2 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
FROM asciidoctor/docker-asciidoctor:1.77.0@sha256:d0879ef599d6288ce6c1fe024f896a77fde77fabda5ac523a582127b4714fc84 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.37@sha256:c52669ab0219f338d502bb5d0b68550e086052f7160ed8c5ca7daf7af9fc04f5 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.2-alpine-slim@sha256:e62bd7bb3c0fd02d31713d55f3eb06794a0b06e63ad4be9cd4a1589a6c57d4ab AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./
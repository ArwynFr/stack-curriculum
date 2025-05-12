FROM asciidoctor/docker-asciidoctor:1.87.0@sha256:efe71f69cf5910b887a5096458281ef2847d72b4c43dcab18b1505466ae05ec3 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.5@sha256:96d92b55063295a037e163790450568c6985b65f8978d1468d2f57a50d765cef AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.28.0-alpine-slim@sha256:c66c3f2dd1878e8b0ed33b8477fbd08d509733fe4febf0038e4c2b47bbe80d4c AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./
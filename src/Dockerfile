FROM asciidoctor/docker-asciidoctor:1.101.0@sha256:7aae24f5d37b4aa543db08cb118257626d6b397b39624bcb07f1feb13aab8d03 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.8@sha256:7d7ba575269b7700f3ac1635532882adfe04b293c98d8548715ca818e782bc0c AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.3-alpine-slim@sha256:c4bc5501a34cb4354ab79536616cb58d8730905bbf2e3ff5ece1f22670cb5f1e AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./
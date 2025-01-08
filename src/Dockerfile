FROM asciidoctor/docker-asciidoctor:1.81.0@sha256:9f0e7488208eabd7f9081bd836577294385e7b8ef860d6e8e8f7d094958d9e32 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.21.2@sha256:ffad8b9a0ec6b1b8188ddc8fcd9408ffb830d22514c9f86238d4ba5e30bc8df2 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.3-alpine-slim@sha256:24235eddde750c5f5cce43f5c4fcae24dc1cbfed9fd1d4de4017b1c0621892e4 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
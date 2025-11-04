FROM asciidoctor/docker-asciidoctor:1.99.0@sha256:8abaa4fc2614757f466699fbb39159d9c07288c72c8ab0d55a590dfe8825a38f AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.6@sha256:b542c8c03f736f6c0e13129078967affb985102ac23978111e17beffd5d769b7 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.2-alpine-slim@sha256:1632c26ddb3249ef8fe939f871f2020dbc00e65f02121a80c66f1dd0cdca9235 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./
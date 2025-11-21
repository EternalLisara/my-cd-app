FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
RUN echo "Server started at: $(date)" > /usr/share/nginx/html/version.txt

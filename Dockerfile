FROM ecwid/ops-test-task:20211208
RUN echo    "server {\n\
        listen 80 default_server;\n\
        listen [::]:80 default_server;\n\
        server_name _;\n\
        location / {\n\
                proxy_pass http://localhost:8082;\n\
                proxy_redirect     off;\n\
                proxy_set_header X-Ecwid-Ops-Test-Task 20211208;\n\
                include proxy_params;\n\
                                }\n\
                location /build/ {\n\
                                autoindex on;\n\
                 root  /opt/box/lib;\n\
                }\n\
}" > /etc/nginx/sites-enabled/box.conf
RUN mkdir /opt/box/lib/build
ADD https://s3.eu-west-2.amazonaws.com/ecwid.ops/devops/startup /startup
ADD https://s3.eu-west-2.amazonaws.com/ecwid.ops/devops/qrcode.js /opt/box/lib/build
ADD https://s3.eu-west-2.amazonaws.com/ecwid.ops/devops/box /etc/init.d/box
RUN chmod 777 /etc/init.d/box && chmod 777 /startup && chmod 777 /opt/box/lib/build/qrcode.js
ENV DEBIAN_FRONTEND=newt
CMD ["/startup"]

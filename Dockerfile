# ==========================================
# Estágio 1: Build (Compilação do Flutter)
# ==========================================
FROM ubuntu:22.04 AS build-env

# Instalar dependências necessárias para o Flutter rodar no Linux
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Baixar e instalar o Flutter (versão stable)
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Inicializar o Flutter
RUN flutter doctor

# Criar a pasta de trabalho dentro do container
WORKDIR /app

# Copiar os arquivos do seu projeto para dentro do container
COPY . .

# Baixar os pacotes e compilar o app para Web
RUN flutter pub get
RUN flutter build web --release

# ==========================================
# Estágio 2: Servidor Web (Nginx)
# ==========================================
FROM nginx:alpine

# Copiar a compilação pronta do Estágio 1 para a pasta pública do Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Expor a porta 80 (O Render vai ler isso e rotear automaticamente)
EXPOSE 80

# Iniciar o servidor Nginx
CMD ["nginx", "-g", "daemon off;"]
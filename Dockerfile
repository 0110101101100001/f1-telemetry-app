# ==========================================
# Estágio 1: Build (Usando imagem oficial pronta)
# ==========================================
FROM ghcr.io/cirruslabs/flutter:stable AS build-env

# Criar a pasta de trabalho
WORKDIR /app

# Copiar os arquivos do projeto
COPY . .

# Comando de segurança para evitar erro de permissão do Git no Docker
RUN git config --global --add safe.directory '*'

# Baixar pacotes e compilar para Web
RUN flutter pub get
RUN flutter build web --release

# ==========================================
# Estágio 2: Servidor Web (Nginx)
# ==========================================
FROM nginx:alpine

# Copiar a compilação pronta para o servidor Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Abrir a porta 80
EXPOSE 80

# Iniciar o servidor
CMD ["nginx", "-g", "daemon off;"]
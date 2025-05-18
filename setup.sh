#!/bin/bash

# Script de Deploy Automatizado do projeto ONGS.

##Como rodar o script?
##### ATENÇAO LEIA O ARQUIVO README.md ANTES DE RODAR O SCRIPT.
# no item 5 de Setup Linux TEM TODAS AS INSTRUÇÕES...

# Carrega variáveis do .env
if [ ! -f .env ]; then
  echo "Arquivo .env não encontrado!"
  exit 1
fi

# Exporta as variáveis do .env
export $(grep -v '^#' .env | xargs -d '\n')

# Debug: Mostrar configurações carregadas
echo "Dominio: $DOMAIN"
echo "Email: $EMAIL"
echo "Usuário: $PROJECT_USER"
echo "Porta: $PROJECT_PORT"
echo "Diretório do Projeto: $PROJECT_DIR"
echo "Virtualenv: $VENV_DIR"
echo "Requirements: $REQUIREMENTS"
echo "Logs: $LOG_DIR"
echo "Supervisor: $SUPERVISOR_CONF"
echo "NGINX: $NGINX_CONF"
echo "Cloudflare Credentials: $CF_API_CREDENTIALS"
echo "Gunicorn: workers=$GUNICORN_WORKERS, threads=$GUNICORN_THREADS"

#variaveis de directorio
PROJECT_DIR="/home/$PROJECT_USER/ONGS"
VENV_DIR="$PROJECT_DIR/venv"
REQUIREMENTS="$PROJECT_DIR/requirements.txt"
LOG_DIR="/home/$PROJECT_USER/logs"
SUPERVISOR_CONF_DIR="/etc/supervisor/conf.d"
SUPERVISOR_CONF="${SUPERVISOR_CONF_DIR}/server_ONGS.conf"
NGINX_CONF="/etc/nginx/sites-available/ONGS"
NGINX_LINK="/etc/nginx/sites-enabled/ONGS"
CF_API_CREDENTIALS="/home/$PROJECT_USER/.cloudflare.ini"

### INÍCIO DO SCRIPT ###
echo "Atualizando sistema e verificando configuraçoes gerais..."

# Verificação de variáveis essenciais
if [[ "$CF_API_TOKEN" == "SEU_API_TOKEN_AQUI" ]]; then
  echo "Erro: Por favor, defina o CF_API_TOKEN corretamente no .env antes de executar o script."
  exit 1
fi

if [[ "$DOMAIN" == "seudominio.com.br" ]]; then
  echo "Erro: Por favor, defina o DOMAIN corretamente no .env antes de executar o script."
  exit 1
fi

if [[ "$EMAIL" == "seu-email@exemplo.com" ]]; then
  echo "Erro: Por favor, defina o EMAIL corretamente no .env antes de executar o script."
  exit 1
fi


sudo apt update && sudo apt upgrade -y

echo "Verificando dependências do Python..."

if ! command -v python3 &> /dev/null; then
    echo "Python3 não encontrado. Instalando..."
    sudo apt install -y python3
else
    echo "Python3 já está instalado: $(python3 --version)"
fi

if ! command -v pip3 &> /dev/null; then
    echo "pip3 não encontrado. Instalando..."
    sudo apt install -y python3-pip
else
    echo "pip3 já está instalado: $(pip3 --version)"
fi

if ! python3 -m venv --help &> /dev/null; then
    echo "python3-venv não está instalado. Instalando..."
    sudo apt install -y python3-venv
else
    echo "python3-venv já está disponível."
fi

echo "Criando virtualenv em $VENV_DIR..."
python3 -m venv $VENV_DIR

echo "Ativando virtualenv e instalando requirements.txt..."
source $VENV_DIR/bin/activate
pip install --upgrade pip

if [ -f "$REQUIREMENTS" ]; then
    pip install -r $REQUIREMENTS
else
    echo "Arquivo requirements.txt não encontrado em $REQUIREMENTS"
fi
deactivate

echo "Verificando dependências do servidor web..."

if ! command -v nginx &> /dev/null; then
    echo "nginx não encontrado. Instalando..."
    sudo apt install -y nginx
else
    echo "nginx já está instalado: $(nginx -v 2>&1)"
fi

if ! command -v supervisord &> /dev/null; then
    echo "supervisor não encontrado. Instalando..."
    sudo apt install -y supervisor
else
    echo "supervisor já está instalado: $(supervisord --version)"
fi

if ! command -v certbot &> /dev/null; then
    echo "certbot não encontrado. Instalando..."
    sudo apt install -y certbot
else
    echo "certbot já está instalado: $(certbot --version)"
fi

if ! python3 -m certbot_dns_cloudflare -h &> /dev/null; then
    echo "Plugin Cloudflare DNS para Certbot não encontrado. Instalando..."
    sudo apt install -y python3-certbot-dns-cloudflare
else
    echo "Plugin Cloudflare DNS já está disponível."
fi

if ! python3 -m certbot_nginx -h &> /dev/null; then
    echo "Plugin Nginx para Certbot não encontrado. Instalando..."
    sudo apt install -y python3-certbot-nginx
else
    echo "Plugin Certbot Nginx já está disponível."
fi

echo "Criando diretório de logs..."
sudo mkdir -p $LOG_DIR
sudo chown $PROJECT_USER:$PROJECT_USER $LOG_DIR

echo "Configurando Supervisor..."
sudo bash -c "cat > $SUPERVISOR_CONF" <<EOL
[program:server_ONGS]
command=$VENV_DIR/bin/gunicorn -w $GUNICORN_WORKERS -b 0.0.0.0:$PROJECT_PORT -k gevent --threads $GUNICORN_THREADS --timeout $GUNICORN_TIMEOUT --max-requests $GUNICORN_MAX_REQUESTS --max-requests-jitter $GUNICORN_JITTER app:app
directory=$PROJECT_DIR
autostart=true
autorestart=true
startsecs=5
startretries=3
stderr_logfile=$LOG_DIR/server_ONGS_err.log
stdout_logfile=$LOG_DIR/server_ONGS_out.log
stdout_logfile_maxbytes=10MB
stdout_logfile_backups=5
user=$PROJECT_USER
environment=PATH="$VENV_DIR/bin:/usr/bin:/bin",VIRTUAL_ENV="$VENV_DIR",PYTHONPATH="$PROJECT_DIR"
EOL

echo "Recarregando Supervisor..."
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart server_ONGS

if [ ! -f "$CF_API_CREDENTIALS" ]; then
    echo "Criando credenciais da API do Cloudflare..."
    sudo bash -c "cat > $CF_API_CREDENTIALS" <<EOF
dns_cloudflare_api_token = $CF_API_TOKEN
EOF
    sudo chmod 600 $CF_API_CREDENTIALS
    sudo chown $PROJECT_USER:$PROJECT_USER $CF_API_CREDENTIALS
else
    echo "Arquivo de credenciais da API do Cloudflare já existe."
fi

echo "Configurando Nginx para wildcard..."
sudo bash -c "cat > $NGINX_CONF" <<EOL
server {
    listen 80;
    server_name ~^(?<subdomain>.+)\.${DOMAIN}\$;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name ~^(?<subdomain>.+)\.${DOMAIN}\$;

    ssl_certificate /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:${PROJECT_PORT};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

if [ ! -L "$NGINX_LINK" ]; then
    sudo ln -s $NGINX_CONF $NGINX_LINK
fi

echo "Testando configuração do Nginx..."
sudo nginx -t && sudo systemctl reload nginx

echo "Solicitando certificado SSL wildcard via DNS Cloudflare..."
sudo certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials $CF_API_CREDENTIALS \
  -d "*.${DOMAIN}" -d "${DOMAIN}" \
  --agree-tos --no-eff-email --email $EMAIL --non-interactive

echo "Recarregando Nginx para aplicar certificado..."
sudo systemctl reload nginx

# === Adicionando cronjob para renovação automática ===
echo "Configurando cronjob para renovação automática de SSL..."
CRON_CMD="certbot renew --dns-cloudflare --dns-cloudflare-credentials $CF_API_CREDENTIALS --quiet --post-hook 'systemctl reload nginx'"
CRON_JOB="0 3 * * * $CRON_CMD"
(crontab -l 2>/dev/null | grep -v -F "$CRON_CMD" ; echo "$CRON_JOB") | crontab -

echo "Setup concluído com sucesso!"
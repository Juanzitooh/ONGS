from dotenv import load_dotenv
import os

# Carrega o .env automaticamente
load_dotenv()

# Recupera valores do ambiente
DOMAIN = os.environ.get("DOMAIN", "seudominio.com.br")

class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY", "uma-chave-secreta")
    DEBUG = os.environ.get("DEBUG", "True").lower() in ("true", "1", "yes")
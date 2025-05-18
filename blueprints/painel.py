from flask import Blueprint

painel_bp = Blueprint('painel', __name__, subdomain='ongs')

@painel_bp.route('/')
def index():
    return "<h1>Painel de Gestão das ONGs</h1>"

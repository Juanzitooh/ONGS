from flask import Blueprint, render_template

ongs_bp = Blueprint(
    'ongs',
    __name__,
    subdomain='ongs',
    static_folder='static',                # pasta relativa ao módulo onde o blueprint está
    static_url_path='/static'              # URL para acessar os arquivos estáticos do blueprint
)

@ongs_bp.route('/')
def index():
    return render_template ('ongs/index.html')

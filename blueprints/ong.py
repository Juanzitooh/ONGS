from flask import Blueprint, render_template
from database.models import get_ong_by_slug, get_sobre_by_slug, get_projetos_by_slug, get_ajuda_by_slug, get_contato_by_slug

# Cria um Blueprint chamado 'ong' que responde para subdomínios dinâmicos,
# onde o subdomínio é recebido como variável <slug>.
# Exemplo: abra.site.com.br -> slug = 'abra'
ong_bp = Blueprint('ong', __name__, subdomain='<slug>')

# Rota raiz do subdomínio: acessa a página principal da ONG baseada no subdomínio. 
@ong_bp.route('/')
def index(slug):
    ong = get_ong_by_slug(slug)
    projetos = get_projetos_by_slug(slug)
    if not ong:
        return render_template('ong/nao_encontrada.html', slug=slug), 404
    return render_template('ong/index.html', ong=ong, projetos=projetos, slug=slug)

@ong_bp.route('/sobre')
def sobre(slug):
    ong = get_ong_by_slug(slug)
    sobre = get_sobre_by_slug(slug)
    if not ong or not sobre:
        return render_template('ong/nao_encontrada.html', slug=slug), 404
    return render_template('ong/sobre.html', ong=ong, sobre=sobre, slug=slug)

@ong_bp.route('/projetos')
def projetos(slug):
    ong = get_ong_by_slug(slug)
    projetos = get_projetos_by_slug(slug)
    if not ong or projetos is None:
        return render_template('ong/nao_encontrada.html', slug=slug), 404
    return render_template('ong/projetos.html', ong=ong, projetos=projetos, slug=slug)

@ong_bp.route('/como-ajudar')
def ajuda(slug):
    ong = get_ong_by_slug(slug)
    ajuda = get_ajuda_by_slug(slug)
    if not ong or ajuda is None:
        return render_template('ong/nao_encontrada.html', slug=slug), 404
    return render_template('ong/ajuda.html', ong=ong, ajuda=ajuda, slug=slug)

@ong_bp.route('/contato')
def contato(slug):
    ong = get_ong_by_slug(slug)
    contato = get_contato_by_slug(slug)
    if not ong or not contato:
        return render_template('ong/nao_encontrada.html', slug=slug), 404
    return render_template('ong/contato.html', ong=ong, contato=contato, slug=slug)
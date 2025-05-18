from flask import Blueprint, render_template

ongs_bp = Blueprint('ongs', __name__, subdomain='ongs')

@ongs_bp.route('/')
def index():
    return render_template ('ongs/index.html')

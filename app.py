from flask import Flask
from config import Config
from blueprints.painel import painel_bp
from blueprints.ong import ong_bp

app = Flask(__name__)
app.config.from_object(Config)

app.config['SERVER_NAME'] = DOMINIO
# Registrar os blueprints
app.register_blueprint(painel_bp)
app.register_blueprint(ong_bp)

if __name__ == '__main__':
    app.run(debug=True)

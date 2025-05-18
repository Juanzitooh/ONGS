from flask import Flask
from config import Config, DOMAIN
from blueprints.ongs import ongs_bp
from blueprints.ong import ong_bp

app = Flask(__name__)
app.config.from_object(Config)

app.config['SERVER_NAME'] = DOMAIN
# Registrar os blueprints
app.register_blueprint(ongs_bp)
app.register_blueprint(ong_bp)
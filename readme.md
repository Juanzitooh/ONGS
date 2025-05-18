# 🏛️ Crie seu site institucional gratuito para ONGs

Bem-vindo ao **ONGS**, uma plataforma **open source** mantida pela [JPTech Solutions](https://jptechsolutions.com.br), criada para que organizações **sem fins lucrativos** tenham seu **próprio site institucional** — de forma **100% gratuita**, **personalizada** e **disponível 24 horas por dia**.

Este projeto nasceu com propósito social, utilizando tecnologias modernas como **Python**, **Gunicorn**, **Nginx**, **Supervisor** e **Certbot**, para facilitar a presença digital de iniciativas que realmente importam.

---

## 👥 Quem pode usar?

### ✅ 1. ONGs que desejam um site pronto, seguro e gratuito

Basta clicar aqui 👉 [**Criar Meu Site Agora**](https://ongs.jptechsolutions.com.br/criar)

Você poderá criar, em poucos minutos, um site institucional com:

- Subdomínio exclusivo (`suaong.jptechsolutions.com.br`)
- Certificado SSL gratuito (cadeado 🔒 no navegador)
- Hospedagem estável 24h por dia
- Sem custo, sem pegadinhas, com suporte incluído

> Tudo isso de forma **automática**, simples e acessível. Totalmente **gratuito**, desde a criação até a hospedagem contínua.

“Apenas entidades sem fins lucrativos com CNPJ válido e regularizado junto à Receita Federal poderão receber visibilidade, doações ou benefícios através da nossa plataforma. Tal medida visa garantir transparência, segurança e legalidade para todos os envolvidos.”

---

### 💻 2. Pessoas que querem **hospedar ONGs em seus próprios servidores**

Este repositório inclui tudo que você precisa para subir a aplicação em servidores **Linux**, com:

- Configuração de **Cloudflare**
- **SSL Wildcard automático**
- Documentação simples e objetiva
- Baixo uso de recursos

> Siga as instruções na seção `▶️ Setup Linux do Projeto ONGS` abaixo.

---

### 🤝 3. Desenvolvedores que desejam contribuir

Você pode ajudar este projeto social a crescer e alcançar mais instituições!  
Colabore de forma simples:

- Faça um **fork** e envie pull requests
- Crie **issues** com melhorias, ideias ou bugs
- Participe das discussões na comunidade

> O projeto está sob [Licença MIT da JPTech Solutions](LICENSE) e é mantido com carinho e propósito.

---

## ❤️ Nossa missão

Facilitar o acesso de ONGs a uma presença digital de qualidade, gratuita, sem depender de agências ou ferramentas comerciais limitadas.  
Porque quem transforma o mundo **merece visibilidade**.

---


# Setup Linux do Projeto ONGS (Para quem quer hospedar ongs)

Este guia é para quem quiser hospedar ongs em seu site.
Para isso criamos esse guia com o script passoa a passo de como usar o  script de iniciaçao automática do projeto com certificado SSL wildcard via Cloudflare, usando Gunicorn, Nginx e Supervisor.

---

## 1. Clonando o Repositório

No terminal, clone o repositório e entre na pasta do projeto:

```bash
git clone https://github.com/juanzitooh/ONGS.git
cd ONGS
````

---

## 2. Pré-requisitos

* Computador ou instancia com Usuário Linux com permissão `sudo` (exemplo: `ubuntu`)
* Domínio configurado no Cloudflare (exemplo: `seudominio.com.br`)
* Caso o domínio **não esteja configurado no Cloudflare e ou nao tenha uma chave token da api da cloudefire**, siga o passo 3
* Se ja tem a chave api e seu dominio usa a cloudfire... vá direto para a edição do setup.
---

## 3. Configurando seu domínio no Cloudflare e gerando API Token

### Como adicionar domínio no Cloudflare

1. Crie uma conta no [Cloudflare](https://www.cloudflare.com/).
2. Adicione seu domínio e siga o processo para alterar os servidores DNS no seu provedor para os servidores da Cloudflare.
3. Aguarde a propagação DNS (pode levar algumas horas).

### Gerar API Token para o script

* No painel do [Cloudflare](https://www.cloudflare.com/), vá em **Perfil > API Tokens > Create Token**.
* Use o template **Edit zone DNS**.
* Restrinja o token ao seu domínio.
* Crie o token e copie o valor gerado (ele só aparecerá uma vez!).

Guarde esse token para usar no passo seguinte.

---


## 4. Configurando o ambiente (.env)

O arquivo `.env` centraliza as variáveis sensíveis e personalizáveis do seu projeto. Basta editar **apenas este arquivo** para ajustar o domínio, e-mail e API da Cloudflare.

---

###  Renomeie o `.env.example` para `.env`

```bash
cp .env.example .env
```

---

###  Edite o `.env`

Abra o `.env` com seu editor favorito e edite **apenas essas 3 variáveis**:

```env
DOMAIN=seudominio.com.br         # Seu domínio principal (ex: meusite.com.br)
EMAIL=seu-email@exemplo.com      # Email de contato das ONGs
CF_API_TOKEN=SEU_API_TOKEN_AQUI  # Token da Cloudflare com permissões de DNS
```

As demais variáveis estão fixas e já configuradas para funcionar corretamente.

---

###  Como isso é usado no projeto?

* O `setup.sh` carrega o `.env` automaticamente usando `source .env`.
* O `config.py` usa `python-dotenv` para ler essas variáveis:

```python
from dotenv import load_dotenv
import os

load_dotenv()

DOMAIN = os.getenv("DOMAIN")
EMAIL = os.getenv("EMAIL")
CF_API_TOKEN = os.getenv("CF_API_TOKEN")
```

> **Você não precisa editar mais nada.** Toda a configuração é feita com base nesse `.env`.

---


## 5. Executando o script de setup

No terminal, estando dentro da pasta principal do projeto (ONGS), execute:

```bash
chmod +x setup.sh
./setup.sh
```

O script irá preparar tudo e deixar o ongs online nos subdominios do seu site/servidor:

* Atualizar o sistema de forma inteligente instalando apenas o que não tiver no seu ambiente
* Instalar dependências (Python, Nginx, Supervisor, Certbot)
* Criar um ambiente virtual Python e instalar os requisitos para rodar o ongs
* Configurar o Supervisor para gerenciar o Gunicorn
* Configurar o Nginx com SSL wildcard via Cloudflare DNS
* Configurar cronjob para renovação automática do certificado
* Deixar o ongs totalmente on no seu dominio.

---

## 6. Verificação final

Após o script terminar, confirme:

* Seu app está rodando no Gunicorn na porta configurada (padrão 8081, veja nos logs).
* Nginx está redirecionando para HTTPS com certificado válido (acesse no navegador: ongs.seudominio.com.br).
* Logs do app estão sendo gerados na pasta configurada (pasta logs).
* Certificado SSL está ativo e a renovação automática está agendada (veja se no site aparece um cadeado verde indicando que é seguro acessar.)

---

## Dúvidas e problemas comuns

* Certifique-se que o domínio está ativo no Cloudflare e com DNS configurado corretamente.
* Se o token API estiver incorreto, a validação DNS para o certificado pode falhar.(gere outro)
* Use `sudo supervisorctl status` para checar o status do app.
* Use `sudo systemctl status nginx` para checar o status do Nginx.
* Logs do Supervisor estão em `/home/ubuntu/logs` (ajuste conforme variável do setup).
*sempre consulte os arquivos de logs, se aparecer algo possivelmente teve algum erro.

---

## Contato e Suporte

Para dúvidas, abra uma issue no repositório com detalhes sobre ela, assim a equipe já fica ciente e pode tomar providências.

---

Código totalmente open source, licenciado sob os termos da [Licença MIT](LICENSE). Sinta-se à vontade para estudar, modificar e contribuir toda ajuda é bem vinda!

© 2025 Juan Pablo de Oliveira Lopes dos Santos. Todos os direitos reservados.
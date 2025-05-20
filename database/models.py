def get_ong_by_slug(slug):
    return {
        "exemplo": {
            "nome": "ABRA",
            "descricao": "Proteção Animal",
            "banner": "banner_exemplo.jpg",
            "logo_icone": "exemplo.png",
            "instagram": "https://www.instagram.com/",
            "facebook": "https://www.facebook.com/"
        }
    }.get(slug)

def get_sobre_by_slug(slug):
    return {
        "exemplo": {
            "historia": "A ABRA foi fundada em 2015 após o resgate de três filhotes abandonados.",
            "missao": "Proteger e cuidar dos animais em situação de risco.",
            "visao": "Ser referência em resgate e adoção de animais no Brasil.",
            "valores": ["Empatia", "Respeito à vida", "Transparência", "Compromisso com a causa"],
            "equipe": "Voluntários, veterinários parceiros e cuidadores dedicados à causa animal.",
            "parceiros": "Clínicas veterinárias locais, prefeitura e empresas amigas dos animais."
        }
    }.get(slug)

def get_projetos_by_slug(slug):
    return {
        "exemplo": [
            {
                "titulo": "Campanha de Adoção",
                "descricao": "Organizamos eventos mensais de adoção com apoio de petshops e voluntários.",
                "imagem": "adocao.jpg",
                "status": "Ativo"
            },
            {
                "titulo": "Castração Solidária",
                "descricao": "Oferecemos castração gratuita para animais de famílias de baixa renda.",
                "imagem": "castracao.jpg",
                "status": "Finalizado"
            },
            {
                "titulo": "Educação Ambiental",
                "descricao": "Realizamos palestras sobre guarda responsável e bem-estar animal em escolas.",
                "imagem": "educacao.jpg",
                "status": "Em Planejamento"
            }
        ]
    }.get(slug)

def get_ajuda_by_slug(slug):
    return {
        "exemplo": {
            "formas": [
                {
                    "titulo": "Doações Financeiras",
                    "descricao": "Você pode contribuir com qualquer valor para nos ajudar a manter os projetos ativos.",
                    "icone": "💰"
                },
                {
                    "titulo": "Doação de Ração e Itens",
                    "descricao": "Aceitamos rações, medicamentos, cobertores, potes, e demais itens para os animais.",
                    "icone": "🐶"
                },
                {
                    "titulo": "Voluntariado",
                    "descricao": "Participe de ações presenciais, eventos de adoção, feiras ou ajude nas redes sociais.",
                    "icone": "🤝"
                },
                {
                    "titulo": "Apadrinhamento",
                    "descricao": "Apadrinhe um animal e ajude mensalmente com os custos de cuidado e tratamento.",
                    "icone": "🎁"
                },
                {
                    "titulo": "Parcerias e Empresas",
                    "descricao": "Empresas podem apoiar através de cotas de patrocínio, doações em produtos ou serviços.",
                    "icone": "🏢"
                }
            ]
        }
    }.get(slug)

def get_contato_by_slug(slug):
    return {
        "exemplo": {
            "endereco": "Rua dos Animais, 123 - São Paulo, SP",
            "telefone": "(11) 98765-4321",
            "cnpj": "11.111.111/0001-00",
            "email": "contato@exemplo.org.br",
            "horario": "Seg a Sex, das 9h às 17h",
            "redes": {
                "instagram": "https://instagram.com/exemplo",
                "facebook": "https://facebook.com/exemplo"
            }
        }
    }.get(slug)

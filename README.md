# BikeGest PWA
## Sistema de Gestão de Oficina Mecânica de Bicicletas

### Como instalar no Android

**Opção 1 — Via arquivo local (mais simples):**
1. Copie toda a pasta para um servidor web (Apache, Nginx, ou use `npx serve .`)
2. Acesse pelo Chrome no Android
3. Chrome mostrará "Adicionar à tela inicial"
4. Toque em instalar → funciona offline!

**Opção 2 — Via GitHub Pages (grátis):**
1. Crie um repositório no GitHub
2. Faça upload desta pasta
3. Ative GitHub Pages nas configurações
4. Acesse a URL pelo Chrome no Android e instale

**Opção 3 — Via servidor local:**
```bash
# Instale o serve globalmente
npm install -g serve

# Execute na pasta do projeto
serve . -p 8080

# Acesse http://SEU_IP:8080 no Android
```

### Estrutura dos arquivos
```
bikegest-pwa/
├── index.html       ← App completo (HTML/CSS/JS)
├── manifest.json    ← Configuração PWA
├── sw.js            ← Service Worker (cache offline)
├── schema.sql       ← Schema do banco de dados
├── icons/           ← Ícones para Android/iOS
│   ├── icon-72.png
│   ├── icon-96.png
│   ├── icon-128.png
│   ├── icon-144.png
│   ├── icon-152.png
│   ├── icon-192.png
│   ├── icon-384.png
│   └── icon-512.png
└── README.md
```

### Credenciais padrão
- **Usuário:** admin
- **Senha:** admin123

### Funcionalidades
- ✅ Login com controle de perfil (Gerente / Vendedor / Mecânico)
- ✅ Cadastro de Clientes, Fornecedores, Bicicletas
- ✅ Gestão de Produtos e Estoque
- ✅ Pedidos de Venda
- ✅ Ordens de Serviço com fluxo de status
- ✅ Relatórios imprimíveis
- ✅ 100% offline (IndexedDB)
- ✅ Bottom navigation para mobile
- ✅ Splash screen
- ✅ Indicador online/offline
- ✅ Instalável como app nativo no Android e iOS

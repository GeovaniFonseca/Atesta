> ## Entendendo decisões arquiteturais e a estrutura do projeto
> 
> ### Estrutura do projeto
> Para este projeto, foi utilizada a arquitetura MVVM (Model-View-ViewModel). A arquitetura MVVM é uma abordagem que separa a lógica de apresentação da lógica de negócios e da lógica de dados. Isso facilita a manutenção, o teste e a escalabilidade do projeto, promovendo uma maior organização e reutilização de código. Cada diretório dentro de '/features' contém views, viewmodels e models:
>   - Views: Responsáveis pela interface do usuário e pela exibição dos dados.
>   - ViewModels: Responsáveis pela lógica de apresentação, atuando como intermediários entre os views e os models.
>   - Models: Representam a lógica de negócios e os dados do aplicativo.   
>
> ### Estrutura da pasta 'lib'
>   - A pasta lib contém o código fonte principal do projeto e está estruturada da seguinte forma:
>    ```bash
>├── ...
>├── lib                           
>│   ├── assets/                   # Imagens e ícones
>│   ├── features/                 # Funcionalidades principais do projeto
>│   │   ├── account/              # Tudo relacionado ao perfil
>│   │   ├── atestado/             # Funcionalidades relacionadas a atestados
>│   │   ├── calendario/           # Funcionalidades do calendário
>│   │   ├── consultas/            # Funcionalidades de consultas
>│   │   ├── exame/                # Funcionalidades relacionadas a exames
>│   │   ├── home/                 # Tela inicial e funcionalidades da home
>│   │   ├── navigation/           # Navegação da aplicação
>│   │   └── vacina/               # Funcionalidades relacionadas a vacinas
>│   ├── services/                 # Serviços de backend, API, etc.
>│   ├── firebase_options.dart     # Configurações do Firebase
>│   ├── main.dart                 # Ponto de entrada da aplicação
>│   └── ...                       # Outros arquivos e pastas relevantes
>└── ...


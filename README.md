> ## Atesta
> 
> A Atesta é uma aplicação Flutter que centraliza todos os seus documentos médicos num único local.
> 
> ### Índice
> 1. [Introduction](#introduction)
> 2. [Features](#features)
> 3. [Ambiente](#ambiente)
> 4. [Instalação](#instalação)
> 5. [Utilização](#utilização)
> 6. [Contributing](#contributing)
> 7. [License](#license)
> 8. [Contact](#contact)
> 
> ### Introduction
> O Atesta foi concebido para ajudar as pessoas a gerir eficazmente os seus documentos médicos. Quer se trate de receitas médicas, resultados de exames ou atestados médicos, Atesta garante que todos os seus documentos são facilmente acessíveis e organizados.
> 
> ### Features
> - **Centralização de documentos:** Guarde todos os seus documentos médicos em um único local.
> - **Acesso fácil:** Recupere rapidamente qualquer documento com alguns toques.
> - **Interface de fácil utilização:** Design intuitivo para uma navegação e utilização fáceis.
> - **Compartilhamento de dados:** Compartilhe seus documentos com o seu médico de uma maneira facil e rapida
> 
> ### Pré-requisitos
> Antes de começar, certifique-se de que preenche os seguintes requisitos:
> - Flutter instalado no seu computador. Siga as instruções [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
> - Firebase CLI instalado. Você pode instalá-lo seguindo as instruções [Firebase CLI setup guide](https://firebase.google.com/docs/flutter/setup?platform=android).
> - Android Studio instalado. Você pode instalá-li aqui [Android Studio](https://developer.android.com/studio)
>
>
> ### Instalação
> Para começar a utilizar o Atesta, siga estes passos:
> 
> 1. Clonar o repositório:
>     ```bash
>     git clone https://github.com/GeovaniFonseca/Atesta.git
>     ```
>
> 2. Instalar as dependências necessárias:
>     - Certifique-se de estar no diretório do projeto.
>     ```bash
>     flutter pub get
>     ```
> 4. Configurar o Firebase:
>     - Inicialize o Firebase no diretório do seu projeto:
>         ```bash
>         flutterfire configure
>         ```
>     - Serviços do Firebase utilizados: **Realtime Database, Authentication, Firestore Database e Storage**.
>     - Criar em **modo de teste**.
>
> 5. Adicione um dispositivo virtual android (Android Virtual Device)
>     - Dispositivo utilizado para o desenvolvimento do projeto  
>       <img src="lib\assets\images\image1.png" alt="Texto Alternativo">
>     - Abra o emulador
>       <img src="lib\assets\images\image2.png" alt="Texto Alternativo">
> 
> 6. Executar a aplicação:
>     ```bash
>     flutter run
>     ```
> 
> ### Utilização
> 1. Abra a aplicação no seu emulador Android.
> 2. Crie uma conta ou inicie sessão se já tiver uma.
> 3. Comece a enviar seus documentos médicos.
> 4. Organize e categorizar seus documentos para fácil recuperação.
> 
> 
> ### License
> This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
> 
> ### Contact
> For any inquiries or issues, please contact:
> - Geovani Fonseca: [GitHub](https://github.com/GeovaniFonseca)

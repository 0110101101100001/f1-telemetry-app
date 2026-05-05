<p>
👨‍💻 <b>Autor</b>
<br>
Kaíque Nunes Vasconcelos Fraga | Desenvolvedor & Data Science Student 
<br>
<br>
<a href="https://www.linkedin.com/in/kaique-nunes-vasconcelos-fraga-580867286/">
  <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" />
</a>
<a href="mailto:kaiquenvf@gmail.com">
  <img src="https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColorAqui está uma versão atualizada e muito mais robusta do seu `README.md`. 

Eu adicionei seções para destacar o **Modo Seminário** que construímos, a profundidade técnica do **Dart 3**, e as novas instruções de infraestrutura usando **Docker e Render**. Isso vai deixar o seu repositório com uma cara de projeto sênior!

Basta copiar o código abaixo e colar no seu arquivo `README.md`:
```markdown
# F1 Live Telemetry Simulator 🏎️

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Render](https://img.shields.io/badge/Render-%46E3B7.svg?style=for-the-badge&logo=render&logoColor=white)

Um aplicativo construído em Flutter que simula a telemetria em tempo real de um carro de Fórmula 1. O projeto possui uma interface visual imersiva e responsiva, fortemente inspirada na identidade da F1 TV, e serve como um **Showcase Técnico** das capacidades avançadas do Dart 3.

🟢 **Live Demo:** https://f1-telemetry-g4au.onrender.com/

## 🏁 Funcionalidades

* **Simulação de Volta Rápida:** Gera dados dinâmicos em tempo real (~30 FPS) com precisão de milésimos de segundo, espelhando a passagem do tempo físico.
* **Modo Seminário Interativo:** Uma tela dividida (Split-Screen) responsiva construída com *Glassmorphism*, contendo slides interativos, blocos de código com *Syntax Highlighting* (Tema Dracula) e o simulador rodando simultaneamente.
* **Interface Estilo F1 TV:** Design agressivo focado no *F1 Red* (#E10600), com botões chanfrados, elementos em itálico e tipografia monospaçada para a fluidez dos dados numéricos.
* **HUD Customizado:** Exibição clara de marcha (GEAR), rotação do motor (RPM), velocidade (SPEED), temperatura dos pneus e parciais de setor.

## 🧠 Foco na Linguagem (Dart 3 Showcase)

Este projeto foi desenhado com um escopo delimitado (sem dependências de hardware externo ou APIs pagas) para evidenciar puramente o amadurecimento lógico e estrutural da linguagem Dart:

* **Concorrência e Assincronismo:** Uso do *Event Loop* do Dart com Streams e funções geradoras (`async*` e `yield`) para processar dados de alta frequência sem causar bloqueio de thread (*Thread Starvation*).
* **Sealed Classes & Pattern Matching:** Restrição da hierarquia de eventos de corrida. O compilador aplica verificação de exaustividade nos blocos `switch`, garantindo segurança absoluta nas transições de estado da UI.
* **Records (Tuplas):** Retorno múltiplo e fortemente tipado de funções analíticas, eliminando a necessidade de criar classes anêmicas (*boilerplate*) descartáveis para transporte de dados.
* **Imutabilidade e Funções de Alta Ordem:** Encadeamento declarativo de métodos (`.map`, `.where`, `.reduce`) para processar fluxos de log puramente, substituindo laços de repetição imperativos.

## 🛠️ Tecnologias e Arquitetura

O projeto adota uma separação de responsabilidades modular:

* `lib/services/api_service.dart`: Lida exclusivamente com a lógica de simulação matemática, formatação de tempo e streams de telemetria.
* `lib/widgets/custom_button.dart`: Componente UI reutilizável contendo as regras visuais da FIA/F1 (bordas e feedback de estado).
* `lib/screens/home_screen.dart`: Consome a stream de dados e reage às atualizações do painel em tempo real.
* `lib/screens/seminar_screen.dart`: Motor de apresentação de slides integrado ao app, renderizando teoria e prática na mesma tela.

### 🐳 Infraestrutura (Docker & Deploy)
O projeto utiliza um pipeline de **Multi-stage Build** no Docker, garantindo paridade de ambiente. O estágio 1 encapsula o Flutter SDK para compilação estática (AOT), e o estágio 2 serve a aplicação via **Nginx** de forma ultra-leve na nuvem (Render).

---

## 🚀 Como Executar

### Opção 1: Execução Local (Flutter SDK)
1. Certifique-se de ter o Flutter SDK instalado.
2. Clone este repositório:

   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git

3. Baixe as dependências:
    ```bash
    flutter pub get

4. Execute o projeto (Web, Desktop ou Mobile):
    ```bash
    flutter run

Opção 2: Execução via Docker

Caso possua o Docker instalado, você pode compilar e rodar o contêiner isoladamente:
  ```bash
  docker build -t f1-telemetry-app .
  docker run -d -p 8080:80 f1-telemetry-app

Acesse http://localhost:8080 no seu navegador.
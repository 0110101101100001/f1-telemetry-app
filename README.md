# F1 Live Telemetry Simulator 🏎️

Um aplicativo construído em Flutter que simula a telemetria em tempo real de um carro de Fórmula 1, trazendo uma interface visual imersiva e responsiva fortemente inspirada na identidade da F1 TV e no grafismo on-board oficial.

## 🏁 Funcionalidades

* **Simulação de Volta Rápida:** Gera dados dinâmicos em tempo real (~30 FPS) com precisão de milésimos de segundo.
* **Interface Estilo F1 TV:** Design agressivo focado no *F1 Red* (#E10600), com botões de cantos chanfrados, elementos em itálico e tipografia monospaçada para a fluidez dos dados numéricos.
* **Gerenciamento de Estado Otimizado:** Utiliza o Pattern Matching (`switch`) do Dart 3 e `sealed classes` para garantir transições de estado limpas e seguras na UI (Aquecimento -> Volta Rápida -> Conclusão).
* **HUD Customizado:** Exibição clara de marcha (GEAR), rotação do motor (RPM), velocidade (SPEED), temperatura dos pneus e parciais de setor.

## 🛠️ Tecnologias e Arquitetura

* **Linguagem:** Dart 3
* **Framework:** Flutter
* **Estrutura de Pastas:** O projeto adota uma separação de responsabilidades modular:
    * `lib/services/api_service.dart`: Lida exclusivamente com a lógica de simulação matemática, formatação de tempo e streams de telemetria.
    * `lib/widgets/custom_button.dart`: Componente UI reutilizável contendo as regras visuais da FIA/F1 (bordas e feedback de estado).
    * `lib/screens/home_screen.dart`: Consome a stream de dados e reage às atualizações do painel em tempo real.

## 🚀 Como Executar

1. Certifique-se de ter o Flutter SDK e as dependências instaladas.
2. Clone este repositório para o seu ambiente local.
3. Baixe os pacotes necessários:
   ```bash
   flutter pub get
4. Execute o projeto no seu emulador ou dispositivo físico:
   ```bash
   flutter run
   
👨‍💻 Autor
Kaíque Nunes Vasconcelos Fraga Desenvolvedor & Data Science Student 
<p align="center">
  <img src="https://img.shields.io/github/stars/0110101101100001?style=flat&color=A0C3FF&label=Stars" />
  <img src="https://img.shields.io/github/followers/0110101101100001?style=flat&color=A0C3FF&label=Followers" />
</p>
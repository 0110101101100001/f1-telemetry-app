import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SeminarScreen extends StatefulWidget {
  const SeminarScreen({super.key});

  @override
  State<SeminarScreen> createState() => _SeminarScreenState();
}

class _SeminarScreenState extends State<SeminarScreen> {
  int _currentSlide = 0;

  List<Widget> get _slides => [
        _buildSlide1(),
        _buildSlide2(),
        _buildSlide3(),
        _buildSlide4(),
      ];

  void _nextSlide() {
    if (_currentSlide < _slides.length - 1) {
      setState(() => _currentSlide++);
    }
  }

  void _prevSlide() {
    if (_currentSlide > 0) {
      setState(() => _currentSlide--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF150B14),
              Color(0xFF000000),
            ],
          ),
        ),
        // LayoutBuilder descobre o tamanho da tela do dispositivo
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Consideramos "mobile" se a largura for menor que 900 pixels
            final isMobile = constraints.maxWidth < 900;

            return Padding(
              padding: EdgeInsets.all(isMobile ? 12.0 : 24.0), // Margem menor no celular
              child: isMobile
                  ? Column(
                      children: [
                        // NO CELULAR: Simulador em cima, Slides embaixo
                        Expanded(flex: 5, child: _buildSimulatorPanel()),
                        const SizedBox(height: 16),
                        Expanded(flex: 5, child: _buildSlidesPanel(isMobile)),
                      ],
                    )
                  : Row(
                      children: [
                        // NO PC: Slides na esquerda, Simulador na direita
                        Expanded(flex: 3, child: _buildSlidesPanel(isMobile)),
                        const SizedBox(width: 24),
                        Expanded(flex: 7, child: _buildSimulatorPanel()),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================
  // PAINEL DE SLIDES (Esquerda no PC, Baixo no Celular)
  // ==========================================
  Widget _buildSlidesPanel(bool isMobile) {
    return GlassContainer(
      child: Column(
        children: [
          // Cabeçalho Fixo do Seminário
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Simulador de Telemetria F1",
                  style: TextStyle(color: Colors.white, fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Showcase Técnica: Dart 3 & Flutter Web",
                  style: TextStyle(color: const Color(0xFFE10600), fontSize: isMobile ? 12 : 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          
          // Área de conteúdo com scroll
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              children: [_slides[_currentSlide]],
            ),
          ),
          
          // Barra de Navegação Inferior
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentSlide > 0 ? _prevSlide : null,
                  icon: const Icon(Icons.arrow_back_ios, size: 12),
                  label: Text(isMobile ? "" : "Anterior"), // Oculta o texto no celular para economizar espaço
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white.withOpacity(0.05),
                    disabledForegroundColor: Colors.white.withOpacity(0.3),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 12),
                  ),
                ),
                Text(
                  "0${_currentSlide + 1} / 0${_slides.length}",
                  style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                ElevatedButton(
                  onPressed: _currentSlide < _slides.length - 1 ? _nextSlide : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE10600),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFE10600).withOpacity(0.3),
                    disabledForegroundColor: Colors.white.withOpacity(0.5),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 12),
                  ),
                  child: Row(
                    children: [
                      Text(isMobile ? "" : "Próximo "), // Oculta o texto no celular
                      const Icon(Icons.arrow_forward_ios, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PAINEL DO SIMULADOR (Direita no PC, Cima no Celular)
  // ==========================================
  Widget _buildSimulatorPanel() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      // O ClipRRect corta as pontas para caber na borda
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        // A "Muralha": Impede que o efeito de vidro do painel de baixo vaze para cá
        child: const RepaintBoundary(
          // Um Scaffold interno garante um fundo 100% sólido e independente
          child: Scaffold(
            backgroundColor: Color(0xFF0D0D12),
            body: HomeScreen(),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SLIDE 1: DESCRIÇÃO DO PROJETO
  // ==========================================
  Widget _buildSlide1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("01. Descrição do Projeto"),
        _buildTopicTag("Contextualização, Viabilidade e Escopo"),
        _buildText(
          "O simulador processa dados críticos de uma volta rápida no circuito de Interlagos, operando sob um modelo estritamente assíncrono.",
        ),
        const SizedBox(height: 16),
        _buildBullet("Real-Time", "Espelhamento de tempo físico e cálculos cinemáticos."),
        _buildBullet("Local Processing", "Geração de dados via algoritmos matemáticos nativos."),
        _buildBullet("Viabilidade", "Sistema simples, focado em performance de pipeline de dados."),
        
        const SizedBox(height: 32),
        _buildTopicTag("Foco na Linguagem: Dart 3"),
        const SizedBox(height: 12),
        _buildFeatureCard(
          icon: Icons.sync,
          title: "Concorrência",
          desc: "Uso do Event Loop para gerenciar eventos de telemetria sem bloquear a Main Thread de renderização.",
        ),
        _buildFeatureCard(
          icon: Icons.security,
          title: "Tipagem Estrita",
          desc: "Aplicação de ADTs (Tipos de Dados Algébricos) para segurança absoluta em transições de estado.",
        ),
        _buildFeatureCard(
          icon: Icons.code,
          title: "Paradigmas",
          desc: "Hibridismo entre Orientação a Objetos e Programação Funcional declarativa.",
        ),
      ],
    );
  }

  // ==========================================
  // SLIDE 2: RECURSOS (SEALED & RECORDS)
  // ==========================================
  Widget _buildSlide2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("02. Recursos da Linguagem"),
        _buildTopicTag("Uso Explícito e Demonstração Técnica"),
        const SizedBox(height: 16),
        
        _buildSubTitle("Sealed Classes & Pattern Matching"),
        _buildText("Garantia de Exaustividade Lógica no processamento de eventos da corrida."),
        const SizedBox(height: 12),
        _buildDraculaCodeBlock([
          _k("sealed class "), _t("TelemetryEvent "), _s("{}\n"),
          _k("class "), _t("LapUpdate "), _k("extends "), _t("TelemetryEvent "), _s("{ ... }\n\n"),
          _c("// O compilador exige o tratamento de todos os casos\n"),
          _k("return switch "), _s("(event) {\n"),
          _t("  LapStarted"), _s("() => renderWarmup(),\n"),
          _t("  TelemetryUpdate"), _s("(:"), _k("var "), _s("speed) => renderHUD(speed),\n"),
          _s("};"),
        ]),

        const SizedBox(height: 32),
        
        _buildSubTitle("Records: Tuplas Eficientes"),
        _buildText("Otimização do tráfego de dados no cálculo de estatísticas setoriais, eliminando classes boilerplate."),
        const SizedBox(height: 12),
        _buildDraculaCodeBlock([
          _c("// Retorno múltiplo com Tipagem Estrutural\n"),
          _s("("), _t("int "), _s("maxSpeed, "), _t("double "), _s("avgTemp) calculateStats() {\n"),
          _k("  return "), _s("("), _n("320"), _s(", "), _n("105.4"), _s(");\n"),
          _s("}\n\n"),
          _c("// Destructuring instantâneo\n"),
          _k("final "), _s("(:maxSpeed, :avgTemp) = calculateStats();"),
        ]),
      ],
    );
  }

  // ==========================================
  // SLIDE 3: RECURSOS (GENERATORS & HOF)
  // ==========================================
  Widget _buildSlide3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("02. Recursos da Linguagem"),
        _buildTopicTag("Continuação Técnica"),
        const SizedBox(height: 16),

        _buildSubTitle("Generators: async* & yield"),
        _buildText("Motor de simulação baseado em Lazy Evaluation e suspensão de execução."),
        const SizedBox(height: 12),
        _buildDraculaCodeBlock([
          _t("Stream"), _s("<"), _t("TelemetryEvent"), _s("> startStream() "), _k("async* "), _s("{\n"),
          _k("  while "), _s("(correndo) {\n"),
          _k("    await "), _t("Future"), _s(".delayed("), _t("Duration"), _s("(ms: "), _n("33"), _s("));\n"),
          _c("    // 'Cospe' o dado e pausa a função\n"),
          _k("    yield "), _t("TelemetryUpdate"), _s("(speed: "), _n("250"), _s(");\n"),
          _s("  }\n"),
          _s("}"),
        ]),

        const SizedBox(height: 32),

        _buildSubTitle("Funções de Alta Ordem"),
        _buildText("Manipulação funcional de coleções para extração de métricas de performance (Pipeline de Dados)."),
        const SizedBox(height: 12),
        _buildDraculaCodeBlock([
          _k("final "), _s("speedList = historico\n"),
          _m("    .where"), _s("((log) => log.sector == "), _str('"S1"'), _s(")\n"),
          _m("    .map"), _s("((log) => log.speed)\n"),
          _m("    .toList"), _s("();\n\n"),
          _c("// Redução para valor escalar\n"),
          _k("final "), _s("max = speedList."), _m("reduce"), _s("((a, b) => a > b ? a : b);"),
        ]),
      ],
    );
  }

  // ==========================================
  // SLIDE 4: ARQUITETURA E ENCERRAMENTO
  // ==========================================
  Widget _buildSlide4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Arquitetura e Encapsulamento"),
        const SizedBox(height: 16),
        
        _buildBullet("Docker", "Encapsulamento de dependências e garantia de Paridade de Ambiente entre Dev e Production."),
        const SizedBox(height: 8),
        _buildBullet("Nginx", "Servidor web leve para entrega de ativos estáticos compilados AOT via Flutter Web."),
        const SizedBox(height: 8),
        _buildBullet("Render", "Pipeline de CI/CD automatizado com deploy baseado em containers Docker."),
        
        const SizedBox(height: 32),
        _buildSectionTitle("Escopo Limitado e Performance"),
        _buildTopicTag("0% Bloqueio de Thread"),
        const SizedBox(height: 8),
        _buildText(
          "O foco do projeto é evidenciar o Dart nativo. Ao limitar o escopo (sem bancos de dados externos), provamos que a linguagem gerencia processamento a 30 FPS de telemetria com consumo de memória negligenciável.",
        ),

        const SizedBox(height: 48),
        Center(
          child: Column(
            children: [
              const Text(
                "Dúvidas?",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Obrigado pela atenção!",
                style: TextStyle(color: Color(0xFFE10600), fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  "Kaíque Nunes & Clarissa Donizetti | GitHub: @0110101101100001",
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // WIDGETS DE DESIGN 
  // ==========================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
    );
  }

  Widget _buildSubTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTopicTag(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE10600).withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE10600).withOpacity(0.5)),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(color: Color(0xFFFF4D4D), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 15, height: 1.6),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildBullet(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: Icon(Icons.circle, size: 8, color: Color(0xFFE10600)),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.5),
                children: [
                  TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title, required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFE10600), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MOTOR DE SYNTAX HIGHLIGHTING (DRACULA)
  // ==========================================
  TextSpan _k(String text) => TextSpan(text: text, style: const TextStyle(color: Color(0xFFFF79C6))); 
  TextSpan _t(String text) => TextSpan(text: text, style: const TextStyle(color: Color(0xFF8BE9FD), fontStyle: FontStyle.italic)); 
  TextSpan _s(String text) => TextSpan(text: text, style: const TextStyle(color: Color(0xFFF8F8F2))); 
  TextSpan _c(String text) => TextSpan(text: text, style: const TextStyle(color: Color(0xFF6272A4))); 
  TextSpan _str(String text) => TextSpan(text: text, style: const TextStyle(color: Color(0xFFF1FA8C))); 
  TextSpan _n(String text) => TextSpan(text: text, style: const TextStyle(color: Color(0xFFBD93F9))); 
  TextSpan _m(String text) => TextSpan(text: text, style: const TextStyle(color: Color(0xFF50FA7B))); 

  Widget _buildDraculaCodeBlock(List<TextSpan> spans) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF282A36),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF44475A)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.5),
          children: spans,
        ),
      ),
    );
  }
}

// ==========================================
// EFEITO DE VIDRO FOSCO (GLASSMORPHISM)
// ==========================================
class GlassContainer extends StatelessWidget {
  final Widget child;
  final Clip clipBehavior;

  const GlassContainer({super.key, required this.child, this.clipBehavior = Clip.hardEdge});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}
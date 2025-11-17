import 'package:flutter/material.dart';
import '../models/pokemon.dart';

/// Tela de exibição dos detalhes completos de um Pokémon específico.
class DetailsPage extends StatelessWidget {
  /// O objeto Pokémon cujos detalhes serão exibidos.
  final Pokemon pokemon;

  const DetailsPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// Título da barra de aplicativos é o nome do Pokémon.
        title: Text(pokemon.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          /// Permite a rolagem caso o conteúdo exceda o espaço disponível.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              // IMAGEM
              /// Exibe a imagem do Pokémon ou um ícone de erro.
              Center(
                child: pokemon.imageUrl.isNotEmpty
                    ? Image.network(
                        pokemon.imageUrl,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 120),
                      )
                    : const Icon(Icons.image_not_supported, size: 120),
              ),

              const SizedBox(height: 20),

              // NOME
              /// Exibe o nome do Pokémon em destaque.
              Text(
                pokemon.name,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // ID
              /// Exibe o ID do Pokémon.
              Text(
                'ID: ${pokemon.id}',
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              // REGIÃO
              /// Exibe a região obtida pelo ID.
              Text(
                "Região: ${getRegionFromId(pokemon.id)}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              // TIPOS
              /// Exibe os tipos do Pokémon usando Chips.
              Wrap(
                spacing: 8,
                children: pokemon.types.map((t) => Chip(label: Text(t))).toList(),
              ),

              const SizedBox(height: 30),

              // TÍTULO STATUS
              if (pokemon.stats.isNotEmpty) ...[
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // EXIBE BARRAS CUSTOMIZADAS
                /// Mapeia as estatísticas em barras de progresso customizadas.
                Column(
                  children: pokemon.stats.entries.map((e) {
                    final statName = e.key;
                    final value = e.value;

                    // Cores diferentes para cada status (lógica de cores)
                    Color barColor = Colors.blue;
                    if (statName == "hp") barColor = Colors.green;
                    if (statName == "attack") barColor = Colors.red;
                    if (statName == "defense") barColor = Colors.blue;
                    if (statName == "speed") barColor = Colors.orange;

                    return StatusBar(
                      label: statName.toUpperCase(),
                      value: value,
                      maxValue: 255, // Valor máximo padrão para stats
                      color: barColor,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Mapeia o ID do Pokémon para a sua respectiva região.
  String getRegionFromId(int id) {
    if (id >= 1 && id <= 151) return "Kanto";
    return "Desconhecida";
  }
}


// -------------------------------------------------------------
// 🟥 CUSTOM STATUS BAR WIDGET
// -------------------------------------------------------------

/// Widget reutilizável que exibe o nome e o valor de uma estatística em uma barra de progresso.
class StatusBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  const StatusBar({
    super.key,
    required this.label,
    required this.value,
    this.maxValue = 255,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    /// Calcula a porcentagem para a barra de progresso, garantindo que esteja entre 0 e 1.
    final double percent = (value / maxValue).clamp(0, 1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Exibe o nome da estatística e seu valor.
          Text(
            "$label: $value",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          /// Barra de progresso visual para a estatística.
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              color: color,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
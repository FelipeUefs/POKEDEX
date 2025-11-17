// ignore_for_file: file_names

class Pokemon {
  /// O identificador único e numérico do Pokémon.
  final int id;
  /// O nome do Pokémon.
  final String name;
  /// O URL para a imagem oficial do Pokémon.
  final String imageUrl;
  /// Lista dos tipos elementais do Pokémon (e.g., 'Fire', 'Water').
  final List<String> types;
  /// Mapa das estatísticas básicas (e.g., 'HP', 'Attack') e seus valores.
  final Map<String, int> stats;

  /// Construtor principal para criar uma nova instância de Pokémon.
  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const [],
    required this.stats,
  });
}

/// Função utilitária para mapear o ID numérico do Pokémon à sua região de origem.
/// Atualmente suporta apenas a região de Kanto (IDs 1 a 151).
String getRegionFromId(int id) {
  if (id >= 1 && id <= 151) return "Kanto";
  return "Região desconhecida";
}
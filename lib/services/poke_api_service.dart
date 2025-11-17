import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

/// Serviço responsável por interagir com a PokeAPI para buscar dados de Pokémons.
class PokeApiService {
  /// URL base para a API de Pokémons.
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  /// Busca uma lista de Pokémons com limites de paginação (`limit` e `offset`).
  /// A busca é limitada aos primeiros 151 Pokémons (Geração I - Kanto).
  Future<List<Pokemon>> fetchPokemons({int limit = 10, int offset = 0}) async {
    const int max = 151; // Limita a busca até o ID 151.

    /// Retorna lista vazia se o offset exceder o limite máximo.
    if (offset >= max) return <Pokemon>[];
    /// Ajusta o limite para não ultrapassar o Pokémon de ID 151.
    if (offset + limit > max) limit = max - offset;

    /// 1. Faz a requisição inicial para obter a lista de Pokémons (nome e URL).
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit&offset=$offset'));
    if (response.statusCode != 200) {
      /// Lança exceção em caso de falha na requisição.
      throw Exception('Falha ao carregar Pokémons');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    final List<Pokemon> pokemons = [];
    /// 2. Itera sobre os resultados para buscar detalhes individuais de cada Pokémon.
    for (final item in results) {
      final url = item['url'] as String;
      final detailResponse = await http.get(Uri.parse(url));
      /// Continua para o próximo se a requisição de detalhes falhar.
      if (detailResponse.statusCode != 200) continue;

      final detailData = jsonDecode(detailResponse.body) as Map<String, dynamic>;
      final id = detailData['id'] as int;
      /// Ignora Pokémons com ID maior que o limite (151).
      if (id > max) continue;

      /// Tenta obter a imagem padrão e, se falhar, tenta a "official-artwork".
      String? image = detailData['sprites']?['front_default'] as String?;
      image ??= detailData['sprites']?['other']?['official-artwork']?['front_default'] as String?;

      /// Extrai a lista de tipos do Pokémon.
      final types = (detailData['types'] as List<dynamic>)
          .map((t) => t['type']['name'] as String)
          .toList();

      /// Extrai e mapeia as estatísticas (nome e base_stat).
      final Map<String, int> statsMap = {};
      for (final s in (detailData['stats'] as List<dynamic>)) {
        final name = s['stat']['name'] as String;
        final base = s['base_stat'] as int;
        statsMap[name] = base;}

      /// Adiciona o objeto Pokémon finalizado à lista.
      pokemons.add(Pokemon(
        id: id,
        name: detailData['name'] as String,
        imageUrl: image ?? '',
        types: types,
        stats: statsMap,));
    }

    /// Retorna a lista de Pokémons construída.
    return pokemons;
  }
}
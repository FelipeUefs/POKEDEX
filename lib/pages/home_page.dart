import 'package:flutter/material.dart';
import '../services/poke_api_service.dart';
import '../models/pokemon.dart';
import 'details_page.dart';

/// Tela inicial que exibe uma lista paginada de Pokémons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Instância do serviço para buscar dados da API.
  final PokeApiService service = PokeApiService();

  /// Posição inicial da lista na API (offset para paginação).
  int offset = 0;
  /// Número de Pokémons a carregar por página (limite).
  final int limit = 10;

  /// Variável que guarda o Future dos Pokémons, reatribuída a cada página.
  late Future<List<Pokemon>> futurePokemons;

  @override
  void initState() {
    super.initState();
    /// Inicia o carregamento da primeira página de Pokémons.
    futurePokemons = service.fetchPokemons(offset: offset, limit: limit);
  }

  /// Função para atualizar o offset e recarregar a lista de Pokémons.
  void loadPage(int newOffset) {
    setState(() {
      offset = newOffset;
      futurePokemons = service.fetchPokemons(offset: offset, limit: limit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// Ocupa o espaço restante e exibe a lista carregada de forma assíncrona.
          Expanded(
            child: FutureBuilder<List<Pokemon>>(
              future: futurePokemons,
              builder: (context, snapshot) {
                /// Exibe um indicador de progresso enquanto os dados estão sendo buscados.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// Exibe mensagem de erro se a busca falhar.
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                /// Lista de Pokémons carregados (ou vazia se nula).
                final pokemons = snapshot.data ?? <Pokemon>[];

                /// Constrói a lista de Pokémons como itens clicáveis.
                return ListView.builder(
                  itemCount: pokemons.length,
                  itemBuilder: (context, index) {
                    final p = pokemons[index];

                    return Card(
                      child: ListTile(
            /// Ícone ou imagem do Pokémon.
            leading: p.imageUrl.isNotEmpty
              ? Image.network(
                p.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 48),
                )
              : const Icon(Icons.image_not_supported, size: 48),
                        title: Text(p.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${p.id}'),
                            const SizedBox(height: 4),
                            /// Exibe os tipos do Pokémon usando Chips.
                            Wrap(
                              spacing: 6,
                              children: p.types
                                  .map((type) => Chip(label: Text(type)))
                                  .toList(),
                            ),
                          ],
                        ),
                        /// Navega para a tela de detalhes ao clicar no item.
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailsPage(pokemon: p),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // PAGINAÇÃO
          /// Área para os botões de navegação da página.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /// Botão "Anterior", desabilitado na primeira página (offset == 0).
                ElevatedButton(
                  onPressed: offset == 0 ? null : () => loadPage(offset - limit),
                  child: const Text('Anterior'),
                ),

                /// Botão "Próxima", desabilitado após o ID 151 (limite da demonstração).
                ElevatedButton(
                  onPressed: (offset + limit >= 151) ? null : () => loadPage(offset + limit),
                  child: const Text('Próxima'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


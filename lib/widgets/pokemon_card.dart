import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../pages/details_page.dart';

/// Um widget [StatelessWidget] que representa um item único de Pokémon na lista.
/// Foi criado para encapsular a lógica de exibição de um Pokémon e a navegação.
class PokemonCard extends StatelessWidget {
  /// O objeto de dados do Pokémon a ser exibido neste cartão.
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        /// Exibe a imagem do Pokémon ou um ícone de fallback.
        leading: pokemon.imageUrl.isNotEmpty
            ? Image.network(
                pokemon.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 48),
              )
            : const Icon(Icons.image_not_supported, size: 48),
        /// Exibe o nome do Pokémon.
        title: Text(
          pokemon.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        /// Exibe os tipos do Pokémon como uma string formatada.
        subtitle: Text(
          "Tipos: ${pokemon.types.join(', ')}",
        ),
        /// Exibe o ID do Pokémon.
        trailing: Text("#${pokemon.id}"),
        
        // 👉 Ao clicar, abre a DetailsPage
        /// Define a ação de clique, navegando para a tela de detalhes.
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(pokemon: pokemon),
            ),
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/details_page.dart';
import 'models/pokemon.dart';

/// Ponto de entrada da aplicação.
void main() {
  runApp(const MyApp());
}

/// Widget principal (root) da aplicação, definindo tema e rotas.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      /// Define o tema visual, usando a cor vermelha como base.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      /// A tela inicial da aplicação é a HomePage.
      home: const HomePage(),
      /// Lógica para gerar rotas dinâmicas (nesse caso, a tela de detalhes).
      onGenerateRoute: (settings) {
        /// Verifica se a rota solicitada é a de detalhes.
        if (settings.name == '/details') {
          final args = settings.arguments;
          /// Garante que o argumento passado é um objeto Pokemon.
          if (args is Pokemon) {
            /// Cria a rota MaterialPageRoute para a tela de detalhes.
            return MaterialPageRoute(
              builder: (_) => DetailsPage(pokemon: args),
            );
          }
        }
        /// Retorna nulo para rotas não reconhecidas.
        return null;
      },
    );
  }
}

//Usei o Gemini pra deixar bem documentado e me ajudar a fazer as firulas de corzinha(em quase tudo que tem, fui fazer só e tava dando cagada) e exibição de status lá no Details_page: )
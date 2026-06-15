# Dicas de Comida 🍳

App Flutter que sugere receitas baseadas nos ingredientes que você tem disponível em casa.

## Funcionalidades ✨

- **Gerenciamento de Ingredientes**: Adicione os ingredientes que você tem em casa
- **Sugestões Inteligentes**: Receitas sugeridas com base nos ingredientes disponíveis
- **Score de Match**: Visualização quantos ingredientes de cada receita você tem
- **Detalhes da Receita**: Ingredientes necessários, modo de preparo, tempo e dificuldade
- **Ingredientes Faltantes**: Lista do que você precisa comprar
- **Favoritos**: Salve suas receitas favoritas
- **Persistência Local**: Seus dados são salvos localmente

## Como Usar 📱

1. **Adicione Ingredientes**: Na tela inicial, toque no botão "+" para adicionar ingredientes
2. **Ver Sugestões**: Com pelo menos 2 ingredientes, toque em "Ver Sugestões de Receitas"
3. **Explore Receitas**: Toque em uma receita para ver detalhes completos
4. **Favoritos**: Use o ícone de coração para salvar receitas favoritas

## Tecnologias 🛠️

- **Flutter**: Framework de desenvolvimento mobile
- **Riverpod**: State management
- **SharedPreferences**: Persistência de dados local

## Estrutura do Projeto 📁

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
│   ├── ingredient.dart
│   ├── recipe.dart
│   └── user_preferences.dart
├── services/                 # Business logic
│   └── recipe_service.dart
├── screens/                   # UI screens
│   ├── home_screen.dart
│   ├── recipes_screen.dart
│   └── recipe_detail_screen.dart
├── widgets/                  # Reusable widgets
│   ├── ingredient_chip.dart
│   ├── recipe_card.dart
│   └── add_ingredient_dialog.dart
└── state/                    # State management
    └── app_state.dart
```

## Instalação e Execução 🚀

1. Certifique-se de ter o Flutter instalado
2. Navegue até o diretório do projeto:
   ```bash
   cd food_suggestions
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o app:
   ```bash
   flutter run
   ```

## Próximas Melhorias 🔮

- Integração com API de receitas (Spoonacular, Edamam)
- Sistema de busca por nome de receita
- Filtros por tipo de cozinha, tempo de preparo
- Upload de fotos de receitas
- Compartilhamento de receitas
- Modo escuro

## Licença 📄

Este projeto é open source e está disponível para uso pessoal.

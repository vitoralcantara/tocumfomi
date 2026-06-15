import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  // Dicionário manual para termos mais comuns de culinária
  static const Map<String, String> _foodDictionary = {
    // Ingredientes básicos
    'chicken': 'frango',
    'beef': 'carne',
    'pork': 'porco',
    'fish': 'peixe',
    'shrimp': 'camarão',
    'egg': 'ovo',
    'eggs': 'ovos',
    'milk': 'leite',
    'cheese': 'queijo',
    'butter': 'manteiga',
    'oil': 'óleo',
    'olive oil': 'azeite',
    'flour': 'farinha',
    'rice': 'arroz',
    'pasta': 'macarrão',
    'bread': 'pão',
    'tomato': 'tomate',
    'onion': 'cebola',
    'garlic': 'alho',
    'potato': 'batata',
    'carrot': 'cenoura',
    'lettuce': 'alface',
    
    // Temperos
    'salt': 'sal',
    'pepper': 'pimenta',
    'sugar': 'açúcar',
    
    // Termos de cozinha
    'easy': 'Fácil',
    'medium': 'Média',
    'hard': 'Difícil',
    'minutes': 'minutos',
    'hour': 'hora',
    'hours': 'horas',
    
    // Categorias
    'breakfast': 'Café da manhã',
    'lunch': 'Almoço',
    'dinner': 'Jantar',
    'dessert': 'Sobremesa',
    'side dish': 'Acompanhamento',
    
    // Cozinhas
    'italian': 'Italiana',
    'mexican': 'Mexicana',
    'chinese': 'Chinesa',
    'japanese': 'Japonesa',
    'indian': 'Indiana',
    'french': 'Francesa',
    'american': 'Americana',
    'british': 'Britânica',
    'spanish': 'Espanhola',
    'brazilian': 'Brasileira',
  };

  // Traduzir usando dicionário manual (mais rápido, sem chamada de API)
  static String translateWithDictionary(String text) {
    final lowerText = text.toLowerCase();
    
    // Verificar tradução exata
    if (_foodDictionary.containsKey(lowerText)) {
      return _foodDictionary[lowerText]!;
    }
    
    // Verificar se contém termos conhecidos e substituir
    String translatedText = text;
    _foodDictionary.forEach((english, portuguese) {
      translatedText = translatedText.replaceAll(
        RegExp(english, caseSensitive: false),
        portuguese,
      );
    });
    
    return translatedText;
  }

  // Traduzir usando API gratuita MyMemory (para frases completas)
  static Future<String> translateWithAPI(String text, {String from = 'en', String to = 'pt'}) async {
    try {
      final url = Uri.parse('https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(text)}&langpair=$from|$to');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['responseStatus'] == 200 && data['responseData'] != null) {
          return data['responseData']['translatedText'] ?? text;
        }
      }
      
      return text; // Fallback para original se falhar
    } catch (e) {
      return text; // Fallback para original se falhar
    }
  }

  // Tradução inteligente: tenta dicionário primeiro, depois API se necessário
  static Future<String> translate(String text) async {
    // Tentar tradução com dicionário primeiro (mais rápido)
    final dictionaryTranslation = translateWithDictionary(text);
    
    // Se foi diferente do original, retorna a tradução do dicionário
    if (dictionaryTranslation.toLowerCase() != text.toLowerCase()) {
      return dictionaryTranslation;
    }
    
    // Se não encontrou no dicionário, usa API para frases mais longas
    if (text.length > 30) {
      return await translateWithAPI(text);
    }
    
    return text; // Mantém original se não encontrou tradução
  }

  // Traduzir lista de ingredientes
  static Future<List<String>> translateIngredients(List<String> ingredients) async {
    final translated = <String>[];
    
    for (final ingredient in ingredients) {
      final translatedIngredient = translateWithDictionary(ingredient);
      translated.add(translatedIngredient);
    }
    
    return translated;
  }
}

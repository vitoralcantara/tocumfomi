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
    'broccoli': 'brócolis',
    'spinach': 'espinafre',
    'mushroom': 'cogumelo',
    'cucumber': 'pepino',
    'zucchini': 'abobrinha',
    'eggplant': 'berinjela',
    'pumpkin': 'abóbora',
    'corn': 'milho',
    'beans': 'feijão',
    'lentils': 'lentilha',
    'chickpeas': 'grão de bico',
    'bell pepper': 'pimentão',
    
    // Carnes
    'bacon': 'bacon',
    'ham': 'presunto',
    'sausage': 'linguiça',
    'turkey': 'peru',
    'duck': 'pato',
    'lamb': 'cordeiro',
    
    // Frutos do mar
    'salmon': 'salmão',
    'tuna': 'atum',
    'crab': 'caranguejo',
    'lobster': 'lagosta',
    'squid': 'lula',
    'octopus': 'polvo',
    
    // Frutas
    'apple': 'maçã',
    'banana': 'banana',
    'orange': 'laranja',
    'lemon': 'limão',
    'lime': 'limão',
    'strawberry': 'morango',
    'blueberry': 'mirtilo',
    'raspberry': 'framboesa',
    'grape': 'uva',
    'watermelon': 'melancia',
    'pineapple': 'abacaxi',
    'mango': 'manga',
    'papaya': 'mamão',
    'avocado': 'abacate',
    'coconut': 'coco',
    
    // Laticínios
    'cream': 'creme',
    'yogurt': 'iogurte',
    'sour cream': 'creme de leite',
    
    // Temperos e ervas
    'salt': 'sal',
    'pepper': 'pimenta',
    'sugar': 'açúcar',
    'seasoning': 'tempero',
    'basil': 'manjericão',
    'oregano': 'orégano',
    'thyme': 'tomilho',
    'rosemary': 'alecrim',
    'parsley': 'salsinha',
    'cilantro': 'coentro',
    'mint': 'hortelã',
    'cumin': 'cominho',
    'paprika': 'páprica',
    'cinnamon': 'canela',
    'vanilla': 'baunilha',
    'nutmeg': 'noz-moscada',
    
    // Outros ingredientes
    'vinegar': 'vinagre',
    'soy sauce': 'molho de soja',
    'ketchup': 'ketchup',
    'mustard': 'mostarda',
    'mayonnaise': 'maionese',
    'honey': 'mel',
    'chocolate': 'chocolate',
    'coffee': 'café',
    'tea': 'chá',
    'water': 'água',
    'juice': 'suco',
    'wine': 'vinho',
    'beer': 'cerveja',
    
    // Termos de cozinha
    'easy': 'Fácil',
    'medium': 'Média',
    'hard': 'Difícil',
    'minutes': 'minutos',
    'hour': 'hora',
    'hours': 'horas',
    'seconds': 'segundos',
    'cup': 'xícara',
    'tablespoon': 'colher de sopa',
    'teaspoon': 'colher de chá',
    'gram': 'grama',
    'kilogram': 'quilograma',
    'liter': 'litro',
    'milliliter': 'mililitro',
    'pound': 'libra',
    'ounce': 'onça',
    'piece': 'pedaço',
    'slices': 'fatias',
    'clove': 'dente',
    
    // Verbos de cozinha
    'chop': 'picar',
    'cut': 'cortar',
    'slice': 'fatiar',
    'dice': 'cortar em cubos',
    'mince': 'picar bem',
    'grate': 'ralar',
    'mix': 'misturar',
    'stir': 'mexer',
    'whisk ingredients': 'bater',
    'beat': 'bater',
    'fold': 'incorporar',
    'knead': 'sovar',
    'roll': 'abrir',
    'shape': 'modelar',
    'coat': 'cobrir',
    'dredge': 'empanar',
    'marinate': 'marinar',
    'season': 'temperar',
    'spice': 'apimentar',
    'salt food': 'salgar',
    'pepper food': 'pimentar',
    'fry': 'fritar',
    'deep fry': 'fritar em imersão',
    'pan fry': 'fritar na frigideira',
    'sauté': 'refogar',
    'stir fry': 'saltear',
    'boil': 'ferver',
    'simmer': 'cozinhar em fogo baixo',
    'poach': 'cozinhar em água fervente',
    'steam': 'cozinhar no vapor',
    'roast': 'assar',
    'bake': 'assar',
    'grill': 'grelhar',
    'barbecue': 'churrasco',
    'broil': 'gratinar',
    'smoke': 'defumar',
    'sear': 'selar',
    'brown': 'dourar',
    'caramelize': 'caramelizar',
    'reduce': 'reduzir',
    'thicken': 'engrossar',
    'thin sauce': 'diluir',
    'blend': 'bater no liquidificador',
    'puree': 'fazer purê',
    'mash': 'amassar',
    'crush': 'esmagar',
    'strain': 'coar',
    'sieve': 'peneirar',
    'drain': 'escorrer',
    'rinse': 'enxaguar',
    'wash': 'lavar',
    'dry': 'secar',
    'pat dry': 'secar com papel toalha',
    'chill': 'resfriar',
    'freeze': 'congelar',
    'thaw': 'descongelar',
    'defrost': 'descongelar',
    'heat': 'aquecer',
    'warm up': 'esquentar',
    'reheat': 'reaquecer',
    'cool': 'esfriar',
    'room temperature': 'temperatura ambiente',
    'refrigerate': 'refrigerar',
    'store': 'armazenar',
    'keep': 'manter',
    'preserve': 'conservar',
    'serve': 'servir',
    'enjoy': 'aproveite',
    'taste': 'provar',
    'adjust': 'ajustar',
    'add': 'adicionar',
    'remove': 'remover',
    'transfer': 'transferir',
    'place': 'colocar',
    'put': 'pôr',
    'set': 'configurar',
    'leave': 'deixar',
    'let': 'deixar',
    'allow': 'permitir',
    'wait': 'esperar',
    'until': 'até',
    'for': 'por',
    'to': 'para',
    'with': 'com',
    'without': 'sem',
    'about': 'cerca de',
    'approximately': 'aproximadamente',
    
    // Utensílios
    'pan': 'panela',
    'pot': 'panela',
    'frying pan': 'frigideira',
    'saucepan': 'caçarola',
    'skillet': 'frigideira',
    'wok': 'wok',
    'baking sheet': 'assadeira',
    'baking dish': 'forma',
    'casserole dish': 'refratório',
    'bowl': 'tigela',
    'mixing bowl': 'tigela',
    'cutting board': 'tábua de corte',
    'knife': 'faca',
    'cutting knife': 'faca',
    'chef knife': 'faca de chef',
    'paring knife': 'faca de legumes',
    'serrated knife': 'faca serrilhada',
    'spoon': 'colher',
    'fork': 'garfo',
    'whisk': 'batedor',
    'spatula': 'espátula',
    'ladle': 'concha',
    'tongs': 'pinça',
    'grater': 'ralador',
    'peeler': 'descascador',
    'can opener': 'abre-latas',
    'measuring cup': 'medidor',
    'measuring spoons': 'medidores',
    'rolling pin': 'rolo de massa',
    'pastry brush': 'pincel',
    'blender': 'liquidificador',
    'food processor': 'processador',
    'mixer': 'batedeira',
    'oven': 'forno',
    'stove': 'fogão',
    'microwave': 'micro-ondas',
    'refrigerator': 'geladeira',
    'freezer': 'congelador',
    
    // Categorias
    'breakfast': 'Café da manhã',
    'lunch': 'Almoço',
    'dinner': 'Jantar',
    'dessert': 'Sobremesa',
    'side dish': 'Acompanhamento',
    'appetizer': 'Aperitivo',
    'snack': 'Lanche',
    'main course': 'Prato principal',
    'salad': 'Salada',
    'soup': 'Sopa',
    'sandwich': 'Sanduíche',
    'pizza': 'Pizza',
    'pasta dish': 'Massa',
    'burger': 'Hambúrguer',
    
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
    'portuguese': 'Portuguesa',
    'argentinian': 'Argentina',
    'thai': 'Tailandesa',
    'vietnamese': 'Vietnamita',
    'korean': 'Coreana',
    'greek': 'Grega',
    'turkish': 'Turca',
    'lebanese': 'Libanesa',
    'moroccan': 'Marroquina',
    'caribbean': 'Caribenha',
    
    // Outros termos comuns
    'recipe': 'receita',
    'ingredient': 'ingrediente',
    'instruction': 'instrução',
    'step': 'passo',
    'method': 'método',
    'preparation': 'preparação',
    'cooking': 'cozimento',
    'serving': 'porção',
    'portion': 'porção',
    'dish': 'prato',
    'meal': 'refeição',
    'food': 'comida',
    'cuisine': 'cozinha',
    'flavor': 'sabor',
    'flavoring': 'gosto',
    'texture': 'textura',
    'aroma': 'aroma',
    'smell': 'cheiro',
    'delicious': 'delicioso',
    'tasty': 'saboroso',
    'yummy': 'gostoso',
    'fresh': 'fresco',
    'hot': 'quente',
    'warm': 'morno',
    'cold': 'frio',
    'crispy': 'crocante',
    'crunchy': 'crocante',
    'soft': 'macio',
    'tender': 'macio',
    'tough': 'duro',
    'juicy': 'suculento',
    'dry food': 'seco',
    'moist': 'úmido',
    'creamy': 'cremoso',
    'smooth': 'suave',
    'rough': 'áspero',
    'thick': 'grosso',
    'thin': 'fino',
    'heavy': 'pesado',
    'light': 'leve',
    'rich': 'rico',
    'bland': 'sem gosto',
    'spicy': 'picante',
    'mild': 'suave',
    'sweet': 'doce',
    'sour': 'azedo',
    'bitter': 'amargo',
    'salty': 'salgado',
    'savory': 'salgado',
    'umami': 'umami',
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

  // Traduzir lista de instruções
  static Future<List<String>> translateInstructions(List<String> instructions) async {
    final translated = <String>[];
    
    for (final instruction in instructions) {
      // Tentar tradução com dicionário primeiro
      final dictionaryTranslation = translateWithDictionary(instruction);
      
      // Se foi diferente do original, retorna a tradução do dicionário
      if (dictionaryTranslation.toLowerCase() != instruction.toLowerCase()) {
        translated.add(dictionaryTranslation);
      } else {
        // Para instruções mais longas, usar API
        if (instruction.length > 20) {
          final apiTranslation = await translateWithAPI(instruction);
          translated.add(apiTranslation);
        } else {
          // Mantém original se não encontrou tradução
          translated.add(instruction);
        }
      }
    }
    
    return translated;
  }
}

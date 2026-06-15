import 'package:flutter/material.dart';

class AddIngredientDialog extends StatefulWidget {
  final List<String> existingIngredients;

  const AddIngredientDialog({
    super.key,
    required this.existingIngredients,
  });

  @override
  State<AddIngredientDialog> createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<AddIngredientDialog> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _suggestions = [
    'tomate',
    'cebola',
    'alho',
    'ovos',
    'arroz',
    'feijão',
    'carne',
    'frango',
    'peixe',
    'queijo',
    'manteiga',
    'azeite',
    'limão',
    'sal',
    'pimenta',
    'macarrão',
    'leite',
    'farinha',
    'batata',
    'cenoura',
  ];
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = _suggestions
        .where((ing) => !widget.existingIngredients.contains(ing))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = _suggestions
            .where((ing) => !widget.existingIngredients.contains(ing))
            .toList();
      } else {
        _filteredSuggestions = _suggestions
            .where((ing) =>
                ing.toLowerCase().contains(query.toLowerCase()) &&
                !widget.existingIngredients.contains(ing))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Ingrediente'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Digite o ingrediente...',
              border: OutlineInputBorder(),
            ),
            onChanged: _filterSuggestions,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.of(context).pop(value.trim());
              }
            },
          ),
          const SizedBox(height: 16),
          if (_filteredSuggestions.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredSuggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredSuggestions[index]),
                    onTap: () {
                      Navigator.of(context).pop(_filteredSuggestions[index]);
                    },
                  );
                },
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _controller.text.trim().isNotEmpty
              ? () => Navigator.of(context).pop(_controller.text.trim())
              : null,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}

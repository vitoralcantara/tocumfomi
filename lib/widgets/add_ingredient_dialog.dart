import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../services/ingredient_service.dart';

class AddIngredientDialog extends StatefulWidget {
  final List<Ingredient> existingIngredients;

  const AddIngredientDialog({
    super.key,
    required this.existingIngredients,
  });

  @override
  State<AddIngredientDialog> createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<AddIngredientDialog> {
  final TextEditingController _controller = TextEditingController();
  List<Ingredient> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _filterSuggestions('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = IngredientService.getAllIngredients()
            .where((ing) => !widget.existingIngredients
                .any((existing) => existing.id == ing.id))
            .toList();
      } else {
        _filteredSuggestions = IngredientService.searchIngredients(query)
            .where((ing) => !widget.existingIngredients
                .any((existing) => existing.id == ing.id))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Ingrediente'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
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
                  final customIngredient =
                      IngredientService.createCustomIngredient(value.trim());
                  Navigator.of(context).pop(customIngredient);
                }
              },
            ),
            const SizedBox(height: 16),
            if (_filteredSuggestions.isNotEmpty)
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredSuggestions.length,
                    itemBuilder: (context, index) {
                      final ingredient = _filteredSuggestions[index];
                      return ListTile(
                        leading: ingredient.emoji != null
                            ? Text(
                                ingredient.emoji!,
                                style: const TextStyle(fontSize: 24),
                              )
                            : const Icon(Icons.restaurant, size: 24),
                        title: Text(ingredient.name),
                        subtitle: Text(ingredient.category),
                        onTap: () {
                          Navigator.of(context).pop(ingredient);
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _controller.text.trim().isNotEmpty
              ? () => Navigator.of(context).pop(
                    IngredientService.createCustomIngredient(
                        _controller.text.trim()),
                  )
              : null,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}

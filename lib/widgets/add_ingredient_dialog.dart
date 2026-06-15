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
  final Set<Ingredient> _selectedIngredients = {};

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

  void _toggleSelection(Ingredient ingredient) {
    setState(() {
      if (_selectedIngredients.contains(ingredient)) {
        _selectedIngredients.remove(ingredient);
      } else {
        _selectedIngredients.add(ingredient);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _selectedIngredients.length;
    
    return Dialog(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Adicionar Ingredientes'),
              elevation: 0,
              actions: [
                if (selectedCount > 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      label: Text('$selectedCount selecionado${selectedCount > 1 ? 's' : ''}'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Pesquisar ingredientes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            _filterSuggestions('');
                          },
                        )
                      : null,
                ),
                onChanged: _filterSuggestions,
              ),
            ),
            const SizedBox(height: 8),
            if (_filteredSuggestions.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    final ingredient = _filteredSuggestions[index];
                    final isSelected = _selectedIngredients.contains(ingredient);
                    
                    return CheckboxListTile(
                      secondary: ingredient.emoji != null
                          ? Text(
                              ingredient.emoji!,
                              style: const TextStyle(fontSize: 24),
                            )
                          : const Icon(Icons.restaurant, size: 24),
                      title: Text(
                        ingredient.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(ingredient.category),
                      value: isSelected,
                      onChanged: (_) => _toggleSelection(ingredient),
                      activeColor: Theme.of(context).colorScheme.primary,
                    );
                  },
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum ingrediente encontrado',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedCount > 0
                          ? () => Navigator.of(context).pop(
                                _selectedIngredients.toList(),
                              )
                          : null,
                      child: Text(
                        selectedCount > 0
                            ? 'Adicionar ($selectedCount)'
                            : 'Adicionar',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

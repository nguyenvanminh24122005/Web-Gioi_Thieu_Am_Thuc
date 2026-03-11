import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../models/recipe.dart';
import '../../providers/recipe_provider.dart';

class RecipeFormScreen extends StatefulWidget {
  final Recipe? recipe;

  const RecipeFormScreen({super.key, this.recipe});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _region = 'Bắc';

  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _nameController.text = widget.recipe!.name;
      _descController.text = widget.recipe!.description;
      _region = widget.recipe!.region;
      _imagePath = widget.recipe!.imagePath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final ext = p.extension(xfile.path);
    final fileName = 'recipe_${DateTime.now().millisecondsSinceEpoch}$ext';
    final savedFile = await File(xfile.path).copy(p.join(dir.path, fileName));

    setState(() {
      _imagePath = savedFile.path;
    });
  }

  String _regionLabel(String region) {
    switch (region) {
      case 'Bắc':
        return 'Miền Bắc';
      case 'Trung':
        return 'Miền Trung';
      case 'Nam':
        return 'Miền Nam';
      default:
        return region;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.recipe != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isEdit ? 'Sửa món' : 'Thêm món',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // IMAGE PICKER CARD
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: _pickImage,
                  child: SizedBox(
                    height: 220,
                    child: _imagePath == null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.add_a_photo_outlined, size: 34),
                                SizedBox(height: 10),
                                Text(
                                  'Chọn ảnh món ăn',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 4),
                                Text('Nhấn để chọn ảnh từ thư viện'),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.file(
                              File(_imagePath!),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // FORM CARD
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên món',
                        prefixIcon: Icon(Icons.restaurant),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Không được để trống';
                        }
                        if (value.trim().length < 2) {
                          return 'Tên quá ngắn';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _region,
                      decoration: const InputDecoration(
                        labelText: 'Miền',
                        prefixIcon: Icon(Icons.place_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Bắc', child: Text('Miền Bắc')),
                        DropdownMenuItem(value: 'Trung', child: Text('Miền Trung')),
                        DropdownMenuItem(value: 'Nam', child: Text('Miền Nam')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _region = value ?? 'Bắc';
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _descController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.notes_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Không được để trống mô tả';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // PREVIEW CHIP
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.red.withOpacity(0.18)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Miền đang chọn: ${_regionLabel(_region)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // SAVE BUTTON
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    if (_imagePath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng chọn ảnh món ăn')),
                      );
                      return;
                    }

                    final provider = context.read<RecipeProvider>();

                    if (isEdit) {
                      final updated = widget.recipe!.copyWith(
                        name: _nameController.text.trim(),
                        region: _region,
                        description: _descController.text.trim(),
                        imagePath: _imagePath,
                      );
                      await provider.updateRecipe(updated);
                    } else {
                      final newRecipe = Recipe(
                        name: _nameController.text.trim(),
                        region: _region,
                        description: _descController.text.trim(),
                        createdAt: DateTime.now(),
                        imagePath: _imagePath,
                      );
                      await provider.addRecipe(newRecipe);
                    }

                    if (mounted) Navigator.pop(context);
                  },
                  child: Text(isEdit ? 'Cập nhật' : 'Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
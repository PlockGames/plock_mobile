import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/services/api.dart';

class TagModel {
  final String id;
  final String name;
  bool isSelected;

  TagModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class TagSelector extends StatefulWidget {
  final List<String> initialSelectedTags;
  final Function(List<String>) onTagsSelected;

  const TagSelector({
    Key? key,
    this.initialSelectedTags = const [],
    required this.onTagsSelected,
  }) : super(key: key);

  @override
  _TagSelectorState createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  final List<TagModel> _tags = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;
  bool _hasError = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTags();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_currentPage < _lastPage && !_isLoading) {
        _loadMoreTags();
      }
    }
  }

  Future<void> _loadTags() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await ApiService.getTags(_currentPage);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

        if (decodedResponse['data'] != null &&
            decodedResponse['data']['data'] != null &&
            decodedResponse['data']['meta'] != null) {
          final List<dynamic> tagsData = decodedResponse['data']['data'];
          final meta = decodedResponse['data']['meta'];

          final List<TagModel> newTags = tagsData
              .map<TagModel>((data) => TagModel.fromJson(data))
              .toList();

          // Check if any of these tags are initially selected
          for (var tag in newTags) {
            if (widget.initialSelectedTags.contains(tag.id)) {
              tag.isSelected = true;
            }
          }

          setState(() {
            _tags.addAll(newTags);
            _lastPage = meta['lastPage'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print('Error loading tags: $e');
    }
  }

  Future<void> _loadMoreTags() async {
    if (_currentPage < _lastPage) {
      setState(() {
        _currentPage++;
        _isLoading = true;
      });
      await _loadTags();
    }
  }

  void _toggleTag(TagModel tag) {
    setState(() {
      tag.isSelected = !tag.isSelected;
    });
  }

  List<String> _getSelectedTagIds() {
    return _tags.where((tag) => tag.isSelected).map((tag) => tag.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Tags',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _hasError
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Failed to load tags'),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _hasError = false;
                          });
                          _loadTags();
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          _tags.length + (_currentPage < _lastPage ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _tags.length) {
                          return _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : SizedBox.shrink();
                        }

                        final tag = _tags[index];
                        return CheckboxListTile(
                          title: Text(tag.name),
                          value: tag.isSelected,
                          onChanged: (_) => _toggleTag(tag),
                          activeColor: Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
                  ),
                ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final selectedTagIds = _getSelectedTagIds();
                    widget.onTagsSelected(selectedTagIds);
                    Navigator.pop(context);
                  },
                  child: Text('Apply'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<String>?> showTagSelector(
  BuildContext context, {
  List<String> initialSelectedTags = const [],
}) async {
  List<String>? result;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return TagSelector(
        initialSelectedTags: initialSelectedTags,
        onTagsSelected: (tags) {
          result = tags;
        },
      );
    },
  );

  return result;
}

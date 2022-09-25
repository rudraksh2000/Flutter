// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = ProductProvider(
      id: null, title: '', description: '', price: null, imageUrl: '');
  var _isInit = true;
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    if (_isInit) {
      // we are forwarding only product id.
      final productId = ModalRoute.of(context).settings.arguments as String;
      // this is to check whether the productId is not new which means we are
      // only loading these values if we are editing a product i.e already
      // existing product.
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        // we are using different way for imageUrl since here we are using
        // TextEditingController for imageUrl therefore we cannot initialize
        // the values as we did for others instead we can do it like this by
        // initializing _imageUrlController.text.
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void updateImageUrl() {
    // here we will update the image when image url input losses focus i.e we
    // move the cursor somewhere else.
    if (!_imageUrlFocusNode.hasFocus) {
      bool isValidUrl = Uri.parse(_imageUrlController.text).isAbsolute;
      // if either of this conditions returns true the image should not load.
      if (_imageUrlController.text.isEmpty ||
          !isValidUrl ||
          (!_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpeg') &&
              !_imageUrlController.text.endsWith('jpg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    // saves the feild values (referred as currenet state of the form).
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _form,
              // here we can also use ListView but the reason for not using is
              // if the list is scrollable it can go out of bounds also to mention
              // the soft keyboad when comes to screen is also pushed and if the
              // we are using list the list will go out of bounds.
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (newValue) {
                        _editedProduct =
                            _editedProduct.copyWith(title: newValue);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the value!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(
                        label: Text('Price'),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (newValue) {
                        _editedProduct = _editedProduct.copyWith(
                            price: double.parse(newValue));
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the value!';
                        }
                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Please enter valid price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: const InputDecoration(
                        label: Text('Description'),
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_imageUrlFocusNode),
                      onSaved: (newValue) {
                        _editedProduct =
                            _editedProduct.copyWith(description: newValue);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the value!';
                        }
                        if (value.length < 10) {
                          return 'Description should be more than 10 charecters!';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.asset(
                                      'assets/images/default_image.png'),
                                )
                              : FittedBox(
                                  fit: BoxFit.fill,
                                  child:
                                      Image.network(_imageUrlController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            // we are using controller here because we want to control
                            // the input text the user types.
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                            onSaved: (newValue) {
                              _editedProduct =
                                  _editedProduct.copyWith(imageUrl: newValue);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the value!';
                              }
                              bool isValidUrl = Uri.parse(value).isAbsolute;
                              if (!isValidUrl) {
                                return 'Please enter valid URL!';
                              }
                              if (!value.endsWith('png') &&
                                  !value.endsWith('jpeg') &&
                                  !value.endsWith('jpg')) {
                                return 'Please enter valid Image URL!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).accentColor,
              ),
              minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, 50),
              ),
            ),
            onPressed: () {
              _saveForm();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

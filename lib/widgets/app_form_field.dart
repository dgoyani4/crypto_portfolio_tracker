import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatefulWidget {
  final bool readOnly;
  final bool syncOnUpdate;
  final GlobalKey<FormFieldState<String>>? textFieldKey;
  final VoidCallback? onTap;
  final String? initialText;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final VoidCallback? onTapOutside;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  // decoration
  final String? labelText;
  final String? titleText;
  final String? hintText;
  final Widget? suffixIcon;

  const AppTextFormField({
    super.key,
    this.readOnly = false,
    this.syncOnUpdate = false,
    this.textFieldKey,
    this.onTap,
    this.initialText,
    this.focusNode,
    this.onChanged,
    this.keyboardType,
    this.controller,
    this.autovalidateMode,
    this.validator,
    this.inputFormatters,
    this.labelText,
    this.titleText,
    this.hintText,
    this.onSubmit,
    this.onTapOutside,
    this.suffixIcon,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  TextEditingController? controller;
  FocusNode _focusNode = FocusNode();
  bool isFocused = false;
  final ValueNotifier<bool> hasError = ValueNotifier<bool>(false);

  @override
  void initState() {
    controller =
        widget.controller ??
        TextEditingController.fromValue(
          TextEditingValue(text: widget.initialText ?? ''),
        );

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.syncOnUpdate && widget.initialText != oldWidget.initialText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateControllerText(widget.initialText ?? '');
        }
      });
    }
  }

  void _updateControllerText(String text) {
    if (controller?.text == text) return;

    final oldValue = controller?.value;

    final newValue = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: (oldValue?.selection.baseOffset ?? text.length).clamp(
          0,
          text.length,
        ),
      ),
    );

    controller?.value = newValue;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    hasError.dispose();

    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    if (widget.controller == null) {
      controller?.dispose();
    }

    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      isFocused = _focusNode.hasFocus;

      if (isFocused && hasError.value) {
        widget.textFieldKey?.currentState?.reset();
        hasError.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: hasError,
      builder: (context, errorState, child) {
        return TextFormField(
          key: widget.textFieldKey,
          readOnly: widget.readOnly,
          controller: controller,
          keyboardType: widget.keyboardType,
          cursorColor: Colors.blue,
          inputFormatters: widget.inputFormatters,
          onChanged: (value) {
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: widget.onSubmit,
          onTap: () {
            widget.onTap?.call();
          },
          onTapOutside: (e) {
            widget.onTapOutside?.call();
            FocusScope.of(context).unfocus();
          },
          focusNode: _focusNode,
          validator: (value) {
            final errorText = widget.validator?.call(value);
            hasError.value = errorText != null;
            return errorText;
          },
          autovalidateMode: widget.autovalidateMode,
          toolbarOptions: ToolbarOptions(
            copy: false,
            paste: false,
            cut: false,
            selectAll: false,
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            counter: SizedBox.shrink(),
            contentPadding: const EdgeInsets.all(12.0),
            filled: true,
            fillColor: Colors.white,
            labelText: (isFocused || controller!.text.isNotEmpty)
                ? (widget.titleText ?? widget.labelText ?? "")
                : (widget.labelText ?? ""),
            labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
            floatingLabelStyle: TextStyle(
              color: (errorState)
                  ? Colors.red
                  : ((isFocused) ? Colors.blue : Colors.grey),
              fontSize: 14,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            suffixIcon: widget.suffixIcon,
            errorMaxLines: 2,
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: (isFocused) ? Colors.blue : Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        );
      },
    );
  }
}

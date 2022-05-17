import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinCodeTextField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String> onSubmitted;
  final TextStyle textStyle;
  final FocusNode focusNode;
  final bool enabled;
  final TextEditingController controller;
  final bool autoDismissKeyboard;
  PinCodeTextField({
    Key key,
    @required this.length,
    this.controller,
    @required this.onChanged,
    this.onCompleted,
    this.focusNode,
    this.enabled = true,
    this.textStyle = const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    this.autoDismissKeyboard = true,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _PinCodeTextFieldState createState() => _PinCodeTextFieldState();
}

class _PinCodeTextFieldState extends State<PinCodeTextField>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingController;
  FocusNode _focusNode;
  List<String> _inputList;

  @override
  void initState() {
    _checkForInvalidValues();
    _assignController();

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    }); // Rebuilds on every change to reflect the correct color on each field.
    _inputList = List<String>(widget.length);
    _initializeValues();

    super.initState();
  }

  // validating all the values
  void _checkForInvalidValues() {
    assert(widget.length != null && widget.length > 0);
    assert(widget.textStyle != null);
  }

  // Assigning the text controller, if empty assiging a new one.
  void _assignController() {
    if (widget.controller == null) {
      _textEditingController = TextEditingController();
    } else {
      _textEditingController = widget.controller;
    }
    _textEditingController.addListener(() {
      var currentText = _textEditingController.text;

      if (widget.enabled && _inputList.join("") != currentText) {
        if (currentText.length >= widget.length) {
          if (widget.onCompleted != null) {
            if (currentText.length > widget.length) {
              // removing extra text longer than the length
              currentText = currentText.substring(0, widget.length);
            }
            //  delay the onComplete event handler to give the onChange event handler enough time to complete
            Future.delayed(Duration(milliseconds: 300),
                    () => widget.onCompleted(currentText));
          }

          if (widget.autoDismissKeyboard) _focusNode.unfocus();
        }
        if (widget.onChanged != null) {
          widget.onChanged(currentText);
        }
      }

      _setTextToInput(currentText);
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeValues() {
    for (int i = 0; i < _inputList.length; i++) {
      _inputList[i] = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: AbsorbPointer(
            absorbing: true, // it prevents on tap on the text field
            child: TextField(
              textInputAction: TextInputAction.done,
              controller: _textEditingController,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                  widget.length,
                ), // this limits the input length
              ],
              // trigger on the complete event handler from the keyboard
              onSubmitted: widget.onSubmitted,
              enableInteractiveSelection: false,
              showCursor: true,
              // this cursor must remain hidden
              cursorColor: Colors.transparent,
              // using same as background color so tha it can blend into the view
              cursorWidth: 0.01,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: TextStyle(
                color: Colors.transparent,
                height: 0.01,
                fontSize:
                0.01, // it is a hidden textfield which should remain transparent and extremely small
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _onFocus,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _generateFields(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _generateFields() {
    var result = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      result.add(
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.rectangle,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 2.0,
                    ),
                  )
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Text(_inputList[i],
                    key: ValueKey(_inputList[i]),
                    style: widget.textStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return result;
  }

  void _onFocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      Future.delayed(const Duration(microseconds: 1), () => FocusScope.of(context).requestFocus(_focusNode));
    }
    else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  void _setTextToInput(String data) async {
    var replaceInputList = List<String>(widget.length);

    for (int i = 0; i < widget.length; i++) {
      replaceInputList[i] = data.length > i ? data[i] : "";
    }

    setState(() {
      _inputList = replaceInputList;
    });
  }
}

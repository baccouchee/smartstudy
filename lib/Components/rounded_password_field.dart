import 'package:flutter/material.dart';
import 'package:smart_study/Components/text_field_container.dart';


class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    bool _obscureText = true;

    return TextFieldContainer(
      child: TextField(
        obscureText: _obscureText,

        onChanged: onChanged,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.black,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.visibility),
            color: Colors.black,
onPressed:( ){
  _obscureText=!_obscureText;
},
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
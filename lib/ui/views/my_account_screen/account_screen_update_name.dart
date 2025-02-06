import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/utils/validations.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/viewmodel/my_account_viewmodel.dart';

class UpdateName extends StatefulWidget {
  String? firstName;
  String? lastName;
  UpdateName({required this.firstName,required this.lastName,Key? key}) : super(key: key);

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  final TextEditingController _firstName = TextEditingController();

  final TextEditingController _lastName = TextEditingController();
  @override
  void initState() {
    _firstName.text = widget.firstName!;
    _lastName.text = widget.lastName!;
    Provider.of<MyAccountViewModel>(context,listen: false).setFirstName(widget.firstName);
    Provider.of<MyAccountViewModel>(context,listen: false).setLastName(widget.lastName);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _disabledButton() {
      return CommonPrimaryButton(
        key: UniqueKey(),
        onPressed: null,
        title: 'Update',
      );
    }
    _activeButton(){
      return CommonPrimaryButton(
        key: UniqueKey(),
        onPressed: ()=>Provider.of<MyAccountViewModel>(context,listen: false).updateName(
          userID: Provider.of<UserDataViewModel>(context,listen: false).userID,
          context: context
        ),
        title: 'Update',
      );
    }
    Widget _inputField({required TextEditingController controller,
       Function(String?)? validator, Function(String)? onChanged,
    required String label}){
      return TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(20),
          FilteringTextInputFormatter.deny(RegExp(r'[\s]'))
        ],
        //  readOnly: edit_first_name,
        controller: controller,
        style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.w400),
        onChanged: (value) => onChanged!(value),
        textCapitalization: TextCapitalization.words,
        onEditingComplete: () {
          FocusManager.instance.primaryFocus!.unfocus();
          //_addressformKey.currentState.validate();
        },
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        validator:(val)=>validator!(val),
      );
    }
    return Consumer<MyAccountViewModel>(
      builder: (context, value, child) {
        return Form(
          key: value.formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              _inputField(controller: _firstName,
                  validator:(val)=> Validations().validateName(val!),
                  label: "First name",
                  onChanged: (v)=>value.setUpdatedFirstName(v)
              ),
              SizedBox(
                height: 30,
              ),
              _inputField(controller: _lastName,
                  validator:(val)=> Validations().validateName(val!),
                  label:"Last name",
                  onChanged: (v)=>value.setUpdatedLastName(v)
              ),
              SizedBox(
                height: 30,
              ),
              value.nameChanged()?_activeButton():_disabledButton()
              //value.nameChanged()?_activeButton():_disabledButton()
            ],
          ),
        );
      }
    );
  }
}

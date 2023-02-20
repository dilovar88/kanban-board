import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../bloc/task/task_bloc.dart';
import '../bloc/task/task_event.dart';

class UserPage extends StatelessWidget {
  UserPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  final accountNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TaskBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("create").tr(),),
      body: FormBuilder(
        key: _formKey,
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: 'account_name',
                  decoration: InputDecoration(
                    labelText: 'account_name'.tr(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.max(128),
                  ]),
                ),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: 'first_name',
                  decoration: InputDecoration(
                    labelText: 'first_name'.tr(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.max(128),
                  ]),
                ),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: 'last_name',
                  decoration: InputDecoration(
                    labelText: 'last_name'.tr(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.max(128),
                  ]),
                ),
                ElevatedButton(onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    print(_formKey.currentState!.value);
                    bloc.add(TaskCreateUser(params: _formKey.currentState!.value));
                  }
                  else {
                    _formKey.currentState?.validate();
                  }
                }, 
                    child: const Text("submit").tr())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

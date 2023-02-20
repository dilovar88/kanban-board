import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:kanban_board/bloc/task/task_bloc.dart';
import 'package:kanban_board/bloc/task/task_event.dart';
import 'package:kanban_board/helpers/constants.dart';
import 'package:kanban_board/models/task.dart';

import '../../helpers/locator.dart';
import '../../models/task_column.dart';

class CreateEditTaskPage extends StatefulWidget {
  CreateEditTaskPage({this.task, Key? key}) : super(key: key);

  Task? task;

  @override
  State<CreateEditTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateEditTaskPage> {
  bool autoValidate = true;
  final _formKey = GlobalKey<FormBuilderState>();
  void _onChanged(dynamic val) => debugPrint(val.toString());

  Color? initialColor;
  Color? tempColor;
  Color? selectedColor = Colors.blue;

  GetIt getIt = GetIt.instance;

  List<FormBuilderFieldOption<String>> columnNames = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initialColor = widget.task != null ? Color(widget.task!.color) : Colors.green;
    selectedColor = widget.task != null ? Color(widget.task!.color) : Colors.green;

    columnNames = [];
    getIt.get<List<TaskColumn>>().forEach((element) {
      columnNames.add(FormBuilderFieldOption(value: element.name, child: Text(element.name.tr()),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.task != null ? "edit" : "create").tr(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => BlocProvider.of<TaskBloc>(context).add(const TaskShowData()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue: {
                  'name': widget.task?.name ?? "",
                  'start_time': widget.task?.startTime ?? DateTime.now(),
                  'task_column': widget.task?.taskColumn?.name,
                },
                skipDisabled: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(
                        labelText: 'name'.tr(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(128),
                      ]),
                    ),
                    const SizedBox(height: 15),

                    FormBuilderDateTimePicker(
                      name: 'start_time',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      inputType: InputType.both,
                      decoration: InputDecoration(
                        labelText: 'start_time'.tr(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['start_time']
                                ?.didChange(null);
                          },
                        ),
                      ),
                      validator: FormBuilderValidators.required(),
                    ),

                    FormBuilderRadioGroup<String>(
                      decoration: InputDecoration(labelText: 'column'.tr()),
                      name: 'task_column',
                      options: columnNames,
                      onChanged: _onChanged,
                      validator: FormBuilderValidators.required(),
                    ),

                    MaterialColorPicker(
                      selectedColor: selectedColor,
                      allowShades: false,
                      onMainColorChange: (color) {
                        setState(() => selectedColor = color);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());

                          final data = {
                            ..._formKey.currentState!.value,
                            'color' : selectedColor?.value
                          };

                          final taskColumn = findTaskColumnByName(name: _formKey.currentState!.value["task_column"]);
                          final task = Task.fromJson(data);

                          if (widget.task != null){
                            widget.task?.updateFrom(task);
                            BlocProvider.of<TaskBloc>(context).add(TaskSave(task: widget.task!, taskColumn: taskColumn, updateMovedTime: false));
                          }
                          else {
                            BlocProvider.of<TaskBloc>(context).add(TaskCreate(task: task, taskColumn: taskColumn));
                          }
                        }
                        else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: Text(
                        'submit'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        BlocProvider.of<TaskBloc>(context).add(const TaskShowData());
                      },
                      child: Text(
                        'back'.tr(),
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
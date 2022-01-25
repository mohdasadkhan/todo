import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/controllers/task_controller.dart';
import 'package:getx/models/task.dart';
import 'package:getx/src/models/theme.dart';
import 'package:getx/src/widgets/button.dart';
import 'package:getx/src/widgets/input_field.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final TaskController _taskController = Get.put(TaskController());
  TextEditingController addTaskController = TextEditingController();
  TextEditingController addNoteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5,10,15,20,25,30];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Task', style: headingStyle,),
              InputField(title: 'Title', hint: 'Enter your title', controller: addTaskController),
              InputField(title: 'Note', hint: 'Enter notes here', controller: addNoteController),
              InputField(title: 'Date', hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey,),
                  onPressed: (){
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(child: InputField(
                    title: 'Start Date',
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: 1==1);
                      },
                      icon: Icon(Icons.access_time_rounded, color: Colors.grey,),
                    ),
                  )),
                  SizedBox(width: 12.0),
                  Expanded(child: InputField(
                    title: 'End Date',
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: 1==2);
                      },
                      icon: Icon(Icons.access_time_rounded, color: Colors.grey,),
                    ),
                  ))
                ],
              ),
              InputField(title: 'Remind', hint: '$_selectedRemind minutes early',
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString())
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                  ),
                ),
              InputField(title: 'Repeat', hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  items: repeatList.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: grey),)
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                  ),
                ),
              SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(text: 'Create Task', onTap: _validateDate)
                ],
              )
              
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(){
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      // backgroundColor: bluishClr,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios, color: Get.isDarkMode ? white : black),
      ),
      actions: [
        Icon(Icons.person, color: Get.isDarkMode ? white : black),
        SizedBox(width: 20.0),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2023),
    );
    if(_pickerDate!=null){
     setState(() {
       _selectedDate = _pickerDate;
       print(_selectedDate);
     });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formatterTime = _pickedTime.format(context);
    if(_pickedTime==null){

    }
    else if(isStartTime == true){
      _startTime = _formatterTime;
    }
    else if(!isStartTime){
      _endTime = _formatterTime;
    }
  }

   _showTimePicker(){
    return showTimePicker(initialEntryMode: TimePickerEntryMode.input, context: context, initialTime: TimeOfDay.now());
  }


  Widget _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle),
        SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  _selectedColor = index;

                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index==0 ? primaryClr : index==1 ? pinkClr : yellowClr,
                  child: _selectedColor==index ? Icon(Icons.done, color: white, size: 16.0) : null,
                ),
              ),
            );
          }),
        )
      ],
    );

  }


  _validateDate(){
    if(addNoteController.text.isNotEmpty && addTaskController.text.isNotEmpty){
      //add data to database
      _addTaskToDatabase();
      Get.back();
    }
    else if(addTaskController.text.isEmpty || addNoteController.text.isEmpty){
      Get.snackbar('Required', 'All Fields are required!',
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.red,
      backgroundColor: white,
        icon: Icon(Icons.warning_amber_outlined)
      );
    }
  }

  _addTaskToDatabase() async {
    int value = await _taskController.addTask(
      task: Task(
        title: addTaskController.text,
        note: addNoteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      )
    );
    print('My id is $value');
  }
}
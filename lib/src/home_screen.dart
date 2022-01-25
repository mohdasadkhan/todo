import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:getx/controllers/task_controller.dart';
import 'package:getx/models/task.dart';
import 'package:getx/services/notificationServices.dart';
import 'package:getx/services/themeServices.dart';
import 'package:getx/src/models/theme.dart';
import 'package:getx/src/screens/add_task_bar.dart';
import 'package:getx/src/widgets/button.dart';
import 'package:getx/src/widgets/taskTile.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body:  Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 20.0),
          _showTask(),
        ],
      ),
    );
  }

 AppBar _appBar(){
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      // backgroundColor: bluishClr,
      leading: GestureDetector(
        onTap: (){
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
            title: 'Theme Changed',
            body: Get.isDarkMode ? 'Activated Dark Theme' : 'Activated Light Theme',
          );
          // print('//going for scheduleNotification');
          // notifyHelper.scheduledNotification();
        },
        // child: Icon(Get.isDarkMode ? Icons.wb_sunny_outlined :Icons.nightlight_round, size: 20.0, color: Get.isDarkMode ? Colors.white : Colors.black,),
        child: Get.isDarkMode ? Icon(Icons.wb_sunny_outlined, size: 20.0, color: Colors.white,) : Icon(Icons.nightlight_round, size: 20.0, color: Colors.black),

      ),
      actions: [
        Icon(Icons.person, color: Get.isDarkMode ? white : black),
        SizedBox(width: 20.0),
      ],
    );
  }

  Widget _addTaskBar(){
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()), style: subHeadingStyle,),
                Text('Today', style: headingStyle,)
              ],
            ),
          ),
          MyButton(text: '+ Add Task', onTap: () async {
            await Get.to(AddTaskPage());
            _taskController.getTasks();
          })
        ],
      ),
    );
  }

  Widget _addDateBar(){
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 10.0),
      child: DatePicker(
        DateTime.now(),
        height: 100.0,
        width: 80.0,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: white,
        dateTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        monthTextStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        onDateChange: (date){
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Widget _showTask(){
    print(_taskController.taskList.length);
    return Expanded(
      child: Obx((){
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index){
            Task task = _taskController.taskList[index];
            print(task.toJson());
            if(task.repeat == 'Daily'){
              DateTime date = DateFormat.jm().parse(task.startTime.toString());
              var myTime = DateFormat('HH:mm').format(date);
              print('myTime -> $myTime');
              notifyHelper.scheduledNotification(int.parse(myTime.toString().split(':')[0]), int.parse(myTime.toString().split(':')[1]), task);
              return _allTask(task: task, index: index);
            }
            if(task.date == DateFormat.yMd().format(_selectedDate)) return _allTask(task: task, index: index);
            return Container();
          }
        );
      })
    );
  }


  _allTask({required Task task, required int index}){
    return AnimationConfiguration.staggeredList(
        position: index,
        child: SlideAnimation(
          child: FadeInAnimation(
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    _showBottomSheet(context, task);
                  },
                  child: TaskTile(task),
                )
              ],
            ),
          ),
        )
    );
  }

  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4.0),
        height: task.isCompleted==1 ? MediaQuery.of(context).size.height*0.22 : MediaQuery.of(context).size.height*0.32,
        color: Get.isDarkMode ? darkGreyClr : white,
        child: Column(
          children: [
            Container(
              height: 5.0,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[500],
              ),
            ),
            Spacer(),
            task.isCompleted == 1 ? Container() :
            _bottomSheetButton(label: 'Task Completed', onTap: (){_taskController.markTaskCompleted(task.id!); Get.back();}, clr: primaryClr, context: context),
            _bottomSheetButton(label: 'Delete Task', onTap: (){_taskController.delete(task); Get.back();}, clr: Colors.red[300]!, context: context),
            SizedBox(height: 20.0),
            _bottomSheetButton(label: 'Close', onTap: (){Get.back();}, clr: white, context: context, isClose: true),
            SizedBox(height: 10.0),
          ],
        ),
      )
    );
  }

  _bottomSheetButton({required String label,required Function() onTap, bool isClose = false, required Color clr, required BuildContext context}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55.0,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          color: isClose ? Colors.transparent : clr,
          border: Border.all(width: 2, color: isClose ? Get.isDarkMode ? grey : black : clr),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(label, style: isClose ? titleStyle : titleStyle.copyWith(color: Colors.white)),   //copyWith will take everything of titleStyle except color
      ),
    );
  }
}
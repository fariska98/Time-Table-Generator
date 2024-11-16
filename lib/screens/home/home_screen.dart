import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table_generation_app/constants/color_class.dart';
import 'package:time_table_generation_app/constants/image_class.dart';
import 'package:time_table_generation_app/constants/text_style_class.dart';
import 'package:time_table_generation_app/provider/timetable_provider.dart';
import 'package:time_table_generation_app/screens/course/course_management_screen.dart';
import 'package:time_table_generation_app/screens/staffs/staff_management_screen.dart';
import 'package:time_table_generation_app/screens/timetable_generator/timetable_generator_screen.dart';
import 'package:time_table_generation_app/utils/app_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   @override
     void initState() {
    super.initState();
    // Load all subjects from the courses collection when the screen initializes
    final timetableProvider = Provider.of<TimetableProvider>(context, listen: false);
    timetableProvider.loadSubjects();
    timetableProvider.loadStaff();
    timetableProvider.loadCourses();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        title: Center(child:   Text('Timetable Generator',
        style: TextStyleClass.manrope700TextStyle(26, ColorClass.black),)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: Image.asset(ImageClass.timtable)),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,       
                  crossAxisSpacing: 16.0,    
                  mainAxisSpacing: 16.0,    
                  childAspectRatio: 1.0,     
                ),
                children: [
                  _buildGridCard(
                    context,
                    title: 'Course Management',
                    icon: Icons.school,
                    onTap: () =>AppUtils.navigateTo(context,const CourseManagementScreen()),
                  ),
               
                  _buildGridCard(
                    context,
                    title: 'Staff Management',
                    icon: Icons.person,
                    onTap: () => AppUtils.navigateTo(context,const StaffManagementScreen()),
                  ),
                  _buildGridCard(
                    context,
                    title: 'Generate TimeTable',
                    icon: Icons.schedule,
                    onTap: () => AppUtils.navigateTo(context,const TimetableGenerationScreen()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: ColorClass.white,
        borderOnForeground: true,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: ColorClass.primaryColor),
            const SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyleClass.manrope600TextStyle(14, ColorClass.black)
            ),
          ],
        ),
      ),
    );
  }
}

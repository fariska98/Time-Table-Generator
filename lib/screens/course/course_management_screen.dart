import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table_generation_app/constants/color_class.dart';
import 'package:time_table_generation_app/constants/text_style_class.dart';
import 'package:time_table_generation_app/models/course_model.dart';
import 'package:time_table_generation_app/provider/timetable_provider.dart';
import 'package:time_table_generation_app/screens/course/widgets/addcourse_pop.dart';
import 'package:time_table_generation_app/screens/course/widgets/edit_course_pop.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  _CourseManagementScreenState createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  final List<TextEditingController> _subjectControllers = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TimetableProvider>(context, listen: false).loadCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _courseNameController.dispose();
    for (var controller in _subjectControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:   Text('Course Management',
        style: TextStyleClass.manrope600TextStyle(20, ColorClass.black),)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                 color: Colors.white,
      
      borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchTextChanged,
                decoration: const InputDecoration(
                  hintText: 'Search courses',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20),),borderSide: BorderSide(color: Color.fromARGB(31, 82, 82, 82))),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<TimetableProvider>(
              builder: (context, provider, child) {
                List<Course> filteredCourses = _filterCourses(provider.courses);
                return ListView.builder(
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    Course course = filteredCourses[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black26),
                          color: const Color.fromARGB(255, 255, 255, 255)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(course.name,
                                  style: TextStyleClass.manrope600TextStyle(16, ColorClass.black),),
                                   SizedBox(
                                    width: 220,
                                    child: Text(course.subjectIds.join(', '),
                                    style: TextStyleClass.manrope600TextStyle(12, ColorClass.black),),
                                    ),
                                ],
                              ),
                              Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,color: ColorClass.primaryColor,),
                              onPressed: () => _editCourseDialog(course, provider),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,color: ColorClass.primaryColor),
                              onPressed: () => _deleteCourse(course, provider),
                            ),
                          ],
                                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        
        backgroundColor: ColorClass.primaryColor,
        label: Text("Add Cource",style: TextStyleClass.manrope600TextStyle(20, ColorClass.white),),
        // child: const Icon(Icons.add),
        onPressed: () => _showAddCourseDialog(context),
      ),
    );
  }

  void _onSearchTextChanged(String query) {
    setState(() {});
  }

  List<Course> _filterCourses(List<Course> courses) {
    if (_searchController.text.isEmpty) {
      return courses;
    } else {
      return courses
          .where((course) => course.name.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }
  }

  void _showAddCourseDialog(BuildContext context) {
    _courseNameController.clear();
    _subjectControllers.clear();
    _subjectControllers.add(TextEditingController());

    showDialog(
      context: context,
      builder: (context) {
        return AddCourseDialog(
          courseNameController: _courseNameController,
          subjectControllers: _subjectControllers,
          onSave: _saveNewCourse,
        );
      },
    );
  }

 void _saveNewCourse() {
  final provider = Provider.of<TimetableProvider>(context, listen: false);

  List<String> subjectIds = _subjectControllers
      .map((controller) => controller.text)
      .where((subject) => subject.isNotEmpty)
      .toList();

  if (_courseNameController.text.isNotEmpty && subjectIds.isNotEmpty) {
    
    Course newCourse = Course(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      name: _courseNameController.text,
      subjectIds: subjectIds,
    );

    
    provider.addCourse(newCourse);

    // Clear the input fields for adding another course
    _courseNameController.clear();
    _subjectControllers.clear();
    _subjectControllers.add(TextEditingController()); // Start with one subject field
  }
}


  void _editCourseDialog(Course course, TimetableProvider provider) {
    _courseNameController.text = course.name;
    _subjectControllers.clear();
    for (var subjectId in course.subjectIds) {
      _subjectControllers.add(TextEditingController(text: subjectId));
    }

    showDialog(
      context: context,
      builder: (context) {
        return EditCourseDialog(
          course: course,
          courseNameController: _courseNameController,
          subjectControllers: _subjectControllers,
          onUpdate: () => _updateCourse(course, provider),
        );
      },
    );
  }

  void _updateCourse(Course course, TimetableProvider provider) {
    course.name = _courseNameController.text;
    course.subjectIds = _subjectControllers
        .map((controller) => controller.text)
        .where((subject) => subject.isNotEmpty)
        .toList();

    provider.updateCourse(course);
  }

  void _deleteCourse(Course course, TimetableProvider provider) async {
    await provider.deleteCourse(course.id!);
  }
}

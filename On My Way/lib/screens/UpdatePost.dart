import 'package:covoiturage_app/contollers/PostController.dart';
import 'package:covoiturage_app/models/Post.dart';
import 'package:covoiturage_app/services/Util.dart';
import 'package:covoiturage_app/widgets/CustomTextField.dart';
import 'package:covoiturage_app/widgets/MyButton.dart';
import 'package:covoiturage_app/widgets/ShowSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdatePost extends StatefulWidget {
  final Post post;

  UpdatePost({Key key, this.post}) : super(key: key);

  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;
  bool isLoading = false;

  PostController _postController;
  String from, to, time, date, price;
  int nbrPlaces;

  TextEditingController _time;
  TextEditingController _date;

  @override
  void initState() {
    super.initState();
    _postController = new PostController();
    _time = new TextEditingController(
        text: Util.convertTimeToString(widget.post.time));
    _date = new TextEditingController(
        text: Util.convertDateToString(widget.post.date));
    from = widget.post.from;
    to = widget.post.to;
    price = widget.post.price;
    nbrPlaces = widget.post.nbrPlaces;
    time = _time.text;
    date = _date.text;
  }

  Future<Null> selectedTime(BuildContext context) async {
    final Future<TimeOfDay> selectedTime = showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    selectedTime.then((value) => {
          _time.text = value.format(context),
          time = _time.text,
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(new Duration(days: 360)),
      // lastDate:DateTime.now().add(new Duration(days: 360)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.text = DateFormat('yyyy-MM-dd').format(picked);
        date = _date.text;
      });
  }

  bool validateForm() {
    if (!_formKey.currentState.validate()) {
      this.setState(() {
        _autoValidate = true;
      });
      return false;
    }
    return true;
  }

  void submitPost() async {
    print(widget.post.toString());
    if (validateForm()) {
      _formKey.currentState.save();
      widget.post.date = Util.convertToDateTime(date);
      widget.post.time = Util.convertToTime(time);
      widget.post.nbrPlaces = nbrPlaces;
      widget.post.from = from;
      widget.post.to = to;
      widget.post.price = price;
      _postController.setPost(widget.post);
      bool result = false;
      this.setState(() => isLoading = true);
      await _postController.updatePost().then((value) => result = value);
      this.setState(() => isLoading = false);
      result == true
          ? {
              Future.delayed(new Duration(milliseconds: 5)).then((value) => {
                    _globalKey.currentState.showSnackBar(
                      SnackBar(
                        content: new ShowSnackBar(
                          color: Colors.green,
                          msg: "Post updated sucessefully",
                        ),
                      ),
                    ),
                    _formKey.currentState.reset(),
                  }),
              Future.delayed(new Duration(seconds: 2)).then(
                (value) => Navigator.pop(context),
              )
              // Navigator.pushReplacement(context, ScaleRoute(page: ())),
            }
          : {
              _globalKey.currentState.showSnackBar(
                SnackBar(
                  content: new ShowSnackBar(
                    color: Colors.red,
                    msg: "Probleme while update your post",
                  ),
                ),
              )
            };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Remove the MediaQuery padding because the demo is rendered inside of a
    // different page that already accounts for this padding.
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: Text("Update Post"),
          actions: [
            FlatButton(
              child: Text(
                "close",
                style: theme.textTheme.bodyText2.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: new BoxDecoration(),
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: [
                        new CustomTextField(
                          initialValue: widget.post.from,
                          icon: Icon(Icons.time_to_leave),
                          hint: "From ",
                          validator: (v) {
                            if (v.length == 0) return "* require";
                          },
                          onSaved: (newValue) => from = newValue,
                        ),
                        new CustomTextField(
                          initialValue: widget.post.to,
                          icon: Icon(Icons.assistant_photo),
                          hint: "To ",
                          validator: (v) {
                            if (v.length == 0) return "* require";
                          },
                          onSaved: (newValue) => to = newValue,
                        ),
                        new CustomTextField(
                          textEditingController: _time,
                          read: true,
                          icon: Icon(Icons.access_time),
                          hint: "Time ",
                          tap: () => this.selectedTime(context),
                          validator: (b) {
                            if (b.length == 0) return "* require";
                          },
                        ),
                        new CustomTextField(
                          textEditingController: _date,
                          read: true,
                          icon: Icon(Icons.data_usage),
                          hint: "Date ",
                          tap: () => _selectDate(context),
                          validator: (b) {
                            if (b.length == 0) return "* require";
                          },
                        ),
                        new CustomTextField(
                          initialValue: widget.post.nbrPlaces.toString(),
                          onSaved: (val) => nbrPlaces = int.parse(val),
                          icon: Icon(Icons.format_list_numbered),
                          hint: "Number of place ",
                          validator: (b) {
                            if (b.length == 0) return "* require";
                          },
                        ),
                        widget.post.price == null
                            ? Container()
                            : new CustomTextField(
                                initialValue: widget.post.price,
                                icon: Icon(Icons.monetization_on),
                                hint: "Price ",
                                validator: (v) {
                                  if (v.length == 0) return "* require";
                                },
                                onSaved: (newValue) => price = newValue,
                              ),
                        new SizedBox(
                          height: 22,
                        ),
                        MyButton("Update post", 2, submitPost),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

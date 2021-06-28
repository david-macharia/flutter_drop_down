
import 'package:drop_down_menu/tools/SizeConfig.dart';
import 'package:flutter/material.dart';

typedef Text DropDownBuilder(int index);
typedef Null OnItemSelected({Text text, dynamic model});

class DropDownBoxDecoration extends BoxDecoration {
  final Color backgroundColor;
  final Color labelColor;
  final Color dropDownColor;
  final Color dropDownItemColor;
  final Color dropDownIconColor;

  const DropDownBoxDecoration(
      {this.backgroundColor = Colors.white,
      this.labelColor = Colors.black,
      this.dropDownColor = Colors.white,
      this.dropDownItemColor = Colors.black,
      this.dropDownIconColor = Colors.black});
}

class DropDownRenderConstraints {
  final Color dropDownColor;
  final Color dropDownItemColor;
  final DropDownSize dropDownSize;

  const DropDownRenderConstraints({
    this.dropDownColor,
    this.dropDownItemColor,
    this.dropDownSize,
  });
}

class DropDownSize {
  final double width;
  final double height;
  final double dropDownSizeFactor;
  const DropDownSize(
      {this.dropDownSizeFactor = 0.2, this.width = 0.1, this.height = 0.1})
      : assert(width != null && height != null),
        assert(
            (width > 0.0 && width <= 1.0) && (height <= 1.0 && height <= 1.0));
}

class DropDown extends StatefulWidget {
  String label;
  OnItemSelected onItemSelected;
  List<dynamic> items = List();
  Map<String, Widget> widgetitems = Map();
  bool reset;
  DropDownBoxDecoration boxDecoration;
  DropDownRenderConstraints dropDownRenderConstraints;
  bool searchable;
  bool dashboardSearchCityDropdown;
  bool signUpSearchAbleDropDown;
  String searchLabel;
  DropDown.customBuilder(
      {this.searchable = false,
      this.dashboardSearchCityDropdown = false,
      this.signUpSearchAbleDropDown = false,
      this.searchLabel,
      this.dropDownRenderConstraints = const DropDownRenderConstraints(
          dropDownSize:
              DropDownSize(width: 0.3, height: 0.3, dropDownSizeFactor: 0.2)),
      this.items = const [],
      this.onItemSelected,
      this.label,
      this.reset = false,
      this.boxDecoration = const DropDownBoxDecoration()});
  DropDown.customBuilderWidget(
      {this.searchable = false,
      this.searchLabel,
      this.dashboardSearchCityDropdown = false,
      this.signUpSearchAbleDropDown = false,
      this.dropDownRenderConstraints = const DropDownRenderConstraints(
          dropDownSize:
              DropDownSize(width: 0.3, height: 0.3, dropDownSizeFactor: 0.2)),
      this.widgetitems = const {},
      this.onItemSelected,
      this.label,
      this.reset = false,
      this.boxDecoration = const DropDownBoxDecoration()});

  @override
  State createState() {
    if (widgetitems.length > 0) {
      return _DropDownWidgetState();
    }
    return _DropDownState();
  }
}

class _DropDownWidgetState extends State<DropDown> with RouteAware {
  final FocusNode _focusNode = FocusNode();

  List<GlobalKey> globalKeys = List();
  FocusNode focusHoder = FocusNode();
  bool shouldShowDropDown = false;
  static final List<OverlayEntry> overlays = List();
  final LayerLink _layerLink = LayerLink();
  Widget currentSelection;
  OverlayEntry _overlayEntry;
  OverlayState overlayState;
  void setCurrentSelection<T extends Widget>({@required T selection}) {
    setState(() {
      currentSelection = selection;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentSelection = Text(widget.label ?? "Select ");
  
  }

  @override
  void dispose() {
  

    if (_overlayEntry != null && overlayState != null) {
      try {
        _overlayEntry.remove();
      } catch (e) {}
    }
    super.dispose();
  }

  @override
  void didPush() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry.remove();
      } catch (e) {}
    }
    // Route was pushed onto navigator and is now topmost route.
  }

  @override
  void didPopNext() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry.remove();
      } catch (e) {}
    }
    // Covering route was popped off the navigator.
  }

  @override
  void initState() {
    globalKeys.clear();
    globalKeys.add(GlobalKey());
    currentSelection = Text(widget.label ?? "Select ");
    overlayState = Overlay.of(context);
  }

  @override
  void deactivate() {
    if (_overlayEntry != null && overlayState != null) {
      try {
        _overlayEntry.remove();
      } catch (e) {}
    }

    super.deactivate();
  }

  void onDropDownIconClicked() {
    if (shouldShowDropDown) {
      shouldShowDropDown = !shouldShowDropDown;
      this._overlayEntry.remove();
    } else {
      this._overlayEntry = this._createOverlayEntry();
      overlayState = Overlay.of(context);

      overlayState.insert(this._overlayEntry);

      shouldShowDropDown = !shouldShowDropDown;
    }

    print("_focusNode.hasFocus");
    // _focusNode.requestFocus();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = globalKeys[0].currentContext.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    //this overlay for widget  dropdown
    return OverlayEntry(builder: (context) {
      if (this.widget.items.isEmpty) {
        return SizedBox();
      }
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: () {
                  if (_overlayEntry != null && overlayState != null) {
                    try {
                      shouldShowDropDown = !shouldShowDropDown;
                      _overlayEntry.remove();
                    } catch (e) {}
                  }
                },
                child: Container(
                  color: Colors.transparent,
                )),
            Positioned(
              left: offset.dx,
              top: 200,
              child: CompositedTransformFollower(
                offset: Offset(0.0, size.height),
                link: this._layerLink,
                child: _SearchableWidgetOverlay(
                  dashboardSearchCityDropdown:
                      this.widget.dashboardSearchCityDropdown,
                  signUpSearchAbleDropDown:
                      this.widget.signUpSearchAbleDropDown,
                  searchLabel: this.widget.searchLabel,
                  onItemSelected: this.widget.onItemSelected,
                  focusNode: _focusNode,
                  widgetItems: widget.widgetitems,
                  searchable: widget.searchable,
                  size: size,
                  setCurrentSelection: setCurrentSelection,
                  dropDownRenderConstraints:
                      this.widget.dropDownRenderConstraints,
                  boxDecoration: this.widget.boxDecoration,
                  currentSelection: currentSelection,
                  onDropDownIconClicked: onDropDownIconClicked,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;

    return CompositedTransformTarget(
      link: this._layerLink,
      child: GestureDetector(
        onTap: onDropDownIconClicked,
        child: Container(
          width: width * widget.dropDownRenderConstraints.dropDownSize.width +
              width * 0.07,
          key: globalKeys[0],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: height * 0.05,
                width:
                    width * widget.dropDownRenderConstraints.dropDownSize.width,
                child: TextFormField(
                  focusNode: this._focusNode,
                  readOnly: true,
                  onTap: onDropDownIconClicked,
                  minLines: 1,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    fillColor: widget.boxDecoration.backgroundColor,
                    filled: true,
                    isDense: false,
                    contentPadding: EdgeInsets.all(5.0), //here your padding
                    hintText: widget.reset == false
                        ? (currentSelection as Text).data
                        : widget.label,
                    hintStyle: TextStyle(fontSize: width * 0.03),
                    enabledBorder: widget.dashboardSearchCityDropdown
                        ? OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(4))
                        : OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(4)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(0)),
                    hasFloatingPlaceholder: false,
                    focusColor: Colors.transparent,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(0)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDropDownIconClicked,
                child: Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    width: width * 0.07,
                    height: height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: widget.boxDecoration.backgroundColor,
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: widget.boxDecoration.dropDownIconColor,
                      size: width * 0.07,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropDownState extends State<DropDown> with RouteAware {
  final FocusNode _focusNode = FocusNode();

  List<GlobalKey> globalKeys = List();
  FocusNode focusHoder = FocusNode();
  bool shouldShowDropDown = false;
  static final List<OverlayEntry> overlays = List();
  final LayerLink _layerLink = LayerLink();
  Widget currentSelection;
  OverlayEntry _overlayEntry;
  OverlayState overlayState;
  void setCurrentSelection<T extends Widget>({@required T selection}) {
    setState(() {
      currentSelection = selection;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
   
  }

  @override
  void dispose() {
 
    super.dispose();
  }

  @override
  void didPush() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry.remove();
      } catch (e) {}
    }
    // Route was pushed onto navigator and is now topmost route.
  }

  @override
  void didPopNext() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry.remove();
      } catch (e) {}
    }
    // Covering route was popped off the navigator.
  }

  @override
  void initState() {
    globalKeys.clear();
    globalKeys.add(GlobalKey());
    currentSelection = Text(widget.label ?? "Select ");
    overlayState = Overlay.of(context);
    print(
        "factor ${this.widget.dropDownRenderConstraints.dropDownSize.dropDownSizeFactor}");
  }

  @override
  void deactivate() {
    if (_overlayEntry != null && overlayState != null) {
      try {
        _overlayEntry.remove();
      } catch (e) {}
    }

    super.deactivate();
  }

  void onDropDownIconClicked() {
    if (shouldShowDropDown) {
      shouldShowDropDown = !shouldShowDropDown;
      this._overlayEntry.remove();
    } else {
      this._overlayEntry = this._createOverlayEntry();
      overlayState = Overlay.of(context);

      overlayState.insert(this._overlayEntry);

      shouldShowDropDown = !shouldShowDropDown;
    }

    print("_focusNode.hasFocus");
    // _focusNode.requestFocus();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = globalKeys[0].currentContext.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(builder: (context) {
      if (this.widget.items.isEmpty) {
        return SizedBox();
      }
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: () {
                  if (_overlayEntry != null && overlayState != null) {
                    try {
                      shouldShowDropDown = !shouldShowDropDown;
                      _overlayEntry.remove();
                    } catch (e) {}
                  }
                },
                child: Container(
                  color: Colors.transparent,
                )),
            Positioned(
              left: offset.dx,
              top: 200,
              child: Container(
                child: CompositedTransformFollower(
                  offset: Offset(0.0, size.height),
                  link: this._layerLink,
                  child: _SearchableOverlay(
                    dashboardSearchCityDropdown:
                        this.widget.dashboardSearchCityDropdown,
                    signUpSearchAbleDropDown:
                        this.widget.signUpSearchAbleDropDown,
                    searchLabel: this.widget.searchLabel,
                    onItemSelected: this.widget.onItemSelected,
                    focusNode: _focusNode,
                    items: widget.items,
                    searchable: widget.searchable,
                    size: size,
                    setCurrentSelection: setCurrentSelection,
                    dropDownRenderConstraints:
                        this.widget.dropDownRenderConstraints,
                    boxDecoration: this.widget.boxDecoration,
                    currentSelection: currentSelection,
                    onDropDownIconClicked: onDropDownIconClicked,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
  
    SizeConfig.init(context);
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;

    return CompositedTransformTarget(
      link: this._layerLink,
      child: GestureDetector(
        onTap: onDropDownIconClicked,
        child: Container(
          decoration: BoxDecoration(),
          width: width * widget.dropDownRenderConstraints.dropDownSize.width +
              width * 0.07,
          key: globalKeys[0],
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: height * 0.05,
                  width: width *
                      widget.dropDownRenderConstraints.dropDownSize.width,
                  child: TextFormField(
                    style: TextStyle(),
                    focusNode: this._focusNode,
                    readOnly: true,
                    onTap: onDropDownIconClicked,
                    minLines: 1,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      fillColor: widget.boxDecoration.backgroundColor,
                      filled: true,
                      isDense: false,

                      contentPadding: EdgeInsets.all(5.0), //here your padding
                      hintText: widget.reset == false
                          ? (currentSelection as Text).data
                          : widget.label,

                      hintStyle: TextStyle(
                        fontSize: width * 0.035,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(0)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(0)),
                      hasFloatingPlaceholder: false,
                      focusColor: Colors.transparent,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(0)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onDropDownIconClicked,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    width: width * 0.07,
                    height: height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: widget.boxDecoration.backgroundColor,
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: widget.boxDecoration.dropDownIconColor,
                      size: width * 0.07,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef void OnCurrentSelection<T extends Widget>({T selection});

class _SearchableWidgetOverlay extends StatefulWidget {
  Map<String, Widget> widgetItems;
  bool searchable;
  Size size;
  Widget currentSelection;
  FocusNode _focusNode;
  DropDownBoxDecoration boxDecoration;
  DropDownRenderConstraints dropDownRenderConstraints;
  OnItemSelected onItemSelected;
  Function onDropDownIconClicked;
  bool reset;
  bool dashboardSearchCityDropdown;
  bool signUpSearchAbleDropDown;
  String label;
  String searchLabel;
  OnCurrentSelection setCurrentSelection;
  _SearchableWidgetOverlay(
      {@required this.onDropDownIconClicked,
      @required this.onItemSelected,
      this.dashboardSearchCityDropdown = false,
      this.signUpSearchAbleDropDown = false,
      @required this.searchLabel,
      @required focusNode,
      @required this.setCurrentSelection,
      @required this.widgetItems,
      @required this.searchable,
      @required this.size,
      @required this.boxDecoration,
      @required this.currentSelection,
      @required this.dropDownRenderConstraints}) {
    this._focusNode = FocusNode();
  }
  @override
  _SearchableWidgetOverlayState createState() =>
      _SearchableWidgetOverlayState();
}

class _SearchableWidgetOverlayState extends State<_SearchableWidgetOverlay> {
  Map<String, Widget> filterlist = Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterlist.addAll(this.widget.widgetItems);
    print("widgets items ${this.widget.widgetItems.length}");
  }

  void _searchEvent(String value) {
    // print("seraching ....................................");
    var search = "r'$value";
    if (value.isEmpty) {
      print("empty");
      filterlist.clear();
      filterlist.addAll(widget.widgetItems);
    } else {
      var items = widget.widgetItems.entries.where((element) {
        return element.key.toLowerCase().contains(value.toLowerCase());
        //return element.title.contains(new RegExp(search, caseSensitive: false));
      });
      filterlist.clear();
      filterlist.addAll(Map.fromEntries(items));
      print("search ${items}");
    }
    print("filter ${filterlist}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;

    return Container(
      child: Material(
        elevation: 0.0,
        child: Container(
          width: widget.size.width,
          height: widget.dashboardSearchCityDropdown
              ? height * 0.7
              : height *
                  widget.dropDownRenderConstraints.dropDownSize
                      .dropDownSizeFactor,
          padding: EdgeInsets.only(bottom: height * 0.02),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(height * 0.02),
                  bottomRight: Radius.circular(height * 0.02))),
          child: Column(
            children: [
              this.widget.searchable
                  ? Flexible(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.01, vertical: height * 0.007),
                        child: Container(
                          height: height * 0.05,
                          child: TextFormField(
                            onTap: () {
                              this.widget._focusNode.requestFocus();
                            },
                            autofocus: true,
                            onChanged: _searchEvent,
                            // focusNode: this.widget._focusNode,
                            readOnly: false,
                            minLines: 1,
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              fillColor: widget.boxDecoration.backgroundColor,
                              filled: true,
                              isDense: false,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0,
                                  horizontal: 5.0), //here your padding
                              hintText: this.widget.searchLabel ?? "Search",
                              hintStyle: TextStyle(fontSize: width * 0.03),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.01)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.01)),
                              hasFloatingPlaceholder: false,
                              focusColor: Colors.transparent,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.01)),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Expanded(
                flex: 1,
                child: Scrollbar(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      itemCount: filterlist.length,
                      itemBuilder: (ctx, value) {
                        return GestureDetector(
                          onTap: () {
                            this.widget.onDropDownIconClicked();

                            setState(() {
                              widget.currentSelection = Text(
                                filterlist.keys.elementAt(value),
                                style: TextStyle(
                                    color: widget.boxDecoration.labelColor,
                                    fontSize: width * 0.03),
                              );
                              this.widget.onItemSelected != null
                                  ? this
                                      .widget //                       .widget
                                      .onItemSelected(
                                          text: widget.currentSelection)
                                  : null;
                            });
                            this.widget.reset = false;
                            this.widget.setCurrentSelection(
                                selection: widget.currentSelection);
                          },
                          child: Container(
                            width: widget.size.width,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                SizedBox(
                                  child: filterlist.values.elementAt(value),
                                  width: widget.size.width * 0.2,
                                  height: widget.size.height,
                                ),
                                Flexible(
                                  child: Text(
                                    filterlist.keys.elementAt(value),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: widget.boxDecoration.labelColor,
                                        fontSize: width * 0.04),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchableOverlay extends StatefulWidget {
  List<dynamic> items;
  bool searchable;
  Size size;
  Widget currentSelection;
  FocusNode _focusNode;
  DropDownBoxDecoration boxDecoration;
  DropDownRenderConstraints dropDownRenderConstraints;
  OnItemSelected onItemSelected;
  Function onDropDownIconClicked;
  bool reset;
  bool dashboardSearchCityDropdown;
  bool signUpSearchAbleDropDown;
  String label;
  String searchLabel;
  OnCurrentSelection setCurrentSelection;
  _SearchableOverlay(
      {@required this.onDropDownIconClicked,
      this.dashboardSearchCityDropdown = false,
      this.signUpSearchAbleDropDown = false,
      @required this.onItemSelected,
      @required this.searchLabel,
      @required focusNode,
      @required this.setCurrentSelection,
      @required this.items,
      @required this.searchable,
      @required this.size,
      @required this.boxDecoration,
      @required this.currentSelection,
      @required this.dropDownRenderConstraints}) {
    this._focusNode = focusNode;
  }
  @override
  __SearchableOverlayState createState() => __SearchableOverlayState();
}

class __SearchableOverlayState extends State<_SearchableOverlay> {
  List<dynamic> filterlist = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterlist.addAll(this.widget.items);
  }

  void _searchEvent(String value) {
    var search = "r'$value";
    if (value.isEmpty) {
      print("empty");
      filterlist.clear();
      filterlist.addAll(widget.items);
    } else {
      var items = widget.items.where((element) {
        return element.toString().toLowerCase().contains(value.toLowerCase());
        //return element.title.contains(new RegExp(search, caseSensitive: false));
      }).toList();

      filterlist.clear();
      filterlist.addAll(items);
      print("search ${items}");
    }
    print("filter ${filterlist}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;

    return Container(
      child: Material(
        elevation: 0.0,
        shape: widget.dashboardSearchCityDropdown
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.04),
              )
            : widget.signUpSearchAbleDropDown
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.04),
                  )
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
        child: Container(
          width: widget.size.width,
          height: widget.dashboardSearchCityDropdown
              ? height * 0.5
              : widget.signUpSearchAbleDropDown
                  ? height * 0.3
                  : height *
                      widget.dropDownRenderConstraints.dropDownSize
                          .dropDownSizeFactor,
          padding: EdgeInsets.only(bottom: height * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            border: widget.dashboardSearchCityDropdown
                ? Border.all(
                    color: Color(0xFF5b1e19),
                  )
                : widget.signUpSearchAbleDropDown
                    ? Border.all(
                        color: Color(0xFF5b1e19),
                      )
                    : null,
            borderRadius: widget.dashboardSearchCityDropdown
                ? BorderRadius.circular(width * 0.04)
                : widget.signUpSearchAbleDropDown
                    ? BorderRadius.circular(width * 0.04)
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(height * 0.02),
                        bottomRight: Radius.circular(height * 0.02),
                      ),
          ),
          child: Column(
            children: [
              this.widget.searchable
                  ? Flexible(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.01, vertical: height * 0.007),
                        child: Container(
                          height: widget.dashboardSearchCityDropdown
                              ? height * 0.045
                              : widget.signUpSearchAbleDropDown
                                  ? height * 0.045
                                  : height * 0.05,
                          child: TextFormField(
                            onChanged: _searchEvent,
                            focusNode: this.widget._focusNode,
                            readOnly: false,
                            minLines: 1,
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              fillColor: widget.boxDecoration.backgroundColor,
                              filled: true,
                              isDense: false,
                              contentPadding: widget.dashboardSearchCityDropdown
                                  ? EdgeInsets.symmetric(
                                      vertical: 3.0,
                                      horizontal: width * 0.04,
                                    )
                                  : widget.signUpSearchAbleDropDown
                                      ? EdgeInsets.symmetric(
                                          vertical: 3.0,
                                          horizontal: width * 0.04,
                                        )
                                      : EdgeInsets.symmetric(
                                          vertical: 3.0,
                                          horizontal: 5.0), //here your padding
                              hintText: this.widget.searchLabel ?? "Search",
                              hintStyle: TextStyle(fontSize: width * 0.03),
                              enabledBorder: widget.dashboardSearchCityDropdown
                                  ? OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF5b1e19),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(width * 0.04),
                                    )
                                  : widget.signUpSearchAbleDropDown
                                      ? OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF5b1e19),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              width * 0.04),
                                        )
                                      : OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              width * 0.01),
                                        ),
                              border: widget.dashboardSearchCityDropdown
                                  ? OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF5b1e19),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(width * 0.04),
                                    )
                                  : widget.signUpSearchAbleDropDown
                                      ? OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF5b1e19),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              width * 0.04),
                                        )
                                      : OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              width * 0.01),
                                        ),
                              hasFloatingPlaceholder: false,
                              focusColor: Colors.transparent,
                              focusedBorder: widget.dashboardSearchCityDropdown
                                  ? OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF5b1e19),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(width * 0.04),
                                    )
                                  : widget.signUpSearchAbleDropDown
                                      ? OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF5b1e19),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              width * 0.04),
                                        )
                                      : OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              width * 0.01),
                                        ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Expanded(
                flex: 1,
                child: Scrollbar(
                  child: ListView.builder(
                    padding: widget.dashboardSearchCityDropdown
                        ? EdgeInsets.symmetric(horizontal: width * 0.02)
                        : widget.signUpSearchAbleDropDown
                            ? EdgeInsets.symmetric(horizontal: width * 0.02)
                            : EdgeInsets.symmetric(horizontal: width * 0.01),
                    itemCount: filterlist.length,
                    itemBuilder: (ctx, value) {
                      return GestureDetector(
                        onTap: () {
                          this.widget.onDropDownIconClicked();

                          setState(
                            () {
                              widget.currentSelection = Text(
                                filterlist[value].toString(),
                                style: TextStyle(
                                    color: widget.boxDecoration.labelColor,
                                    fontSize: width * 0.03),
                              );

                              this.widget.onItemSelected != null
                                  ? this
                                      .widget //                       .widget
                                      .onItemSelected(
                                          text: widget.currentSelection,
                                          model: filterlist[value])
                                  : null;
                            },
                          );
                          this.widget.reset = false;
                          this.widget.setCurrentSelection(
                              selection: widget.currentSelection);
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            filterlist[value].toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: widget.boxDecoration.labelColor,
                                fontSize: width * 0.04),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

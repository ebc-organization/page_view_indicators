import 'package:flutter/material.dart';

class StepPageIndicator extends StatefulWidget {
  static const double _defaultSize = 8.0;
  static const double _defaultSpacing = 8.0;
  static const Color _defaultStepColor = Colors.green;

  /// The current page index ValueNotifier
  final ValueNotifier<int> currentPageNotifier;

  /// The number of items managed by the PageController
  final int itemCount;

  ///The step color
  final Color stepColor;

  ///The step size
  final double height;

  ///The space between steps
  final double stepSpacing;

  ///The step display widget for the previous steps
  final Widget? previousStep;

  ///The step display widget for the next steps
  final Widget? nextStep;

  ///The step display widget for the selected step
  final Widget? selectedStep;

  ///The offset value to animate, an average of width of prev,current and next widgets if it is provided
  /// Offset for scroll animation  will be ====( this * index )==== You need to experiment different values
  /// as per the width of indicators you gave
  final double animationOffset;

  const StepPageIndicator({
    Key? key,
    required this.currentPageNotifier,
    required this.itemCount,
    this.height = _defaultSize,
    this.stepSpacing = _defaultSpacing,
    Color? stepColor,
    this.previousStep,
    this.selectedStep,
    this.nextStep, required this.animationOffset,
  })  : this.stepColor = stepColor ?? _defaultStepColor,
        assert(height >= 0, "size must be a positive number"),
        super(key: key);

  @override
  _StepPageIndicatorState createState() {
    return _StepPageIndicatorState();
  }
}

class _StepPageIndicatorState extends State<StepPageIndicator> {
  int _currentPageIndex = 0;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _readCurrentPageIndex();
    widget.currentPageNotifier.addListener(_handlePageIndex);
    super.initState();
  }

  @override
  void dispose() {
    widget.currentPageNotifier.removeListener(_handlePageIndex);
    super.dispose();
  }

  _scrollWithIndex(int index) {
    scrollController.animateTo(index * widget.animationOffset,
        duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,

      child: Center(
        child: ListView.separated(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.itemCount,
          itemBuilder: (_, index) {
            return _getStep(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: widget.stepSpacing,
            );
          },
        ),
      ),
    );
  }

  bool isSelected(int dotIndex) => _currentPageIndex == dotIndex;

  bool isPrevious(int dotIndex) => _currentPageIndex > dotIndex;

  bool isNext(int dotIndex) => _currentPageIndex < dotIndex;

  _handlePageIndex() {
    setState(_readCurrentPageIndex);
    _scrollWithIndex(widget.currentPageNotifier.value);
  }

  _readCurrentPageIndex() {
    _currentPageIndex = widget.currentPageNotifier.value;
  }

  _getStep(int index) {
    if (isPrevious(index)) {
      return widget.previousStep ??
          Container(
            width: widget.height,
            height: widget.height ,
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: widget.stepColor)),
            child: FittedBox(
              child: Icon(
                Icons.check,
                color: widget.stepColor,
              ),
            ),
          );
    } else if (isSelected(index)) {
      return widget.selectedStep ??
          Container(
            width: widget.height,
            height: widget.height,
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: widget.stepColor)),
            child: Container(
                margin: const EdgeInsets.all(2),
                width: widget.height,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.stepColor,
                  shape: BoxShape.circle,
                )),
          );
    } else {
      return widget.nextStep ??
          Container(
            width: widget.height,
            height: widget.height,
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: widget.stepColor)),
          );
    }
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moolwms/utils/dev_utils.dart';
typedef PaginationBuilder<T> = Future<List<T>> Function(int currentListSize);
typedef ItemWidgetBuilder<T> = Widget Function(int index, T item);
class Pagination<T> extends StatefulWidget {
    const Pagination(
      {Key? key,
      this.isSearching = false,
      this.pageBuilder,
      this.itemBuilder,
      this.scrollDirection = Axis.vertical,
      this.progress,
      this.onError,
      this.reverse = false,
      this.shrinkWrap = false,
      this.controller,
      this.primary,
      this.physics,
      this.padding,
      this.itemExtent,
      this.cacheExtent,
      this.semanticChildCount,
      this.topWidget ,
      this.bottomWidget})
      : assert(pageBuilder != null),
        assert(itemBuilder != null),
        super(key: key);

  /// Called when the list scrolls to an end
  ///
  /// Function should return Future List of type 'T'
  final PaginationBuilder<T>? pageBuilder;

  /// Called to build children for [Pagination]
  ///
  /// Function should return a widget
  final ItemWidgetBuilder<T>? itemBuilder;

  /// Scroll direction of list view
  final Axis scrollDirection;

  /// When non-null [progress] widget is called to show loading progress
  final Widget? progress;

  /// Handle error returned by the Future implemented in [pageBuilder]
  final Function(dynamic error)? onError;

  /// Custom Top Widget
  final Widget? topWidget;

  /// Custom Bottom Widget
  final Widget? bottomWidget;
  final bool? isSearching;

  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  // final bool addAutomaticKeepAlive = true;
  final bool addRepaintBoundaries = true;
  final bool addSemanticIndexes = true;
  final double? cacheExtent;
  final int? semanticChildCount;

  @override
  PaginationState<T> createState() => PaginationState<T>();
}

class PaginationState<T> extends State<Pagination<T>> {
  final List<T> _list = [];
  bool _isLoading = false;
  bool _isEndOfList = false;

  void clearList() {
    setState(() {
      _list.clear();
      _isLoading = false;
      _isEndOfList = false;
      fetchMore();
    });
  }

  void fetchMore() {
    _isEndOfList = true;
    _isLoading = false;
    if (!_isLoading) {
      _isLoading = true;
      widget.pageBuilder!(_list.length).then((list) {
        _isLoading = false;
        if (list.isEmpty) {
          _isEndOfList = true;
        }
        setState(() {
          _list.addAll(list);
          if (widget.isSearching!) {
            _isEndOfList = true;
          }
        });
      }).catchError((error) {
        setState(() {
          _isEndOfList = true;
        });
        logPrint.e(error);
        if (widget.onError != null) {
          widget.onError!(error);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    
  
   fetchMore();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: widget.padding,
      controller: widget.controller,
      physics: widget.physics,
      primary: widget.primary,
      reverse: widget.reverse,
      shrinkWrap: widget.shrinkWrap,
      itemExtent: widget.itemExtent,
      cacheExtent: widget.cacheExtent,
      // addAutomaticKeepAlive: widget.addAutomaticKeepAlive,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      scrollDirection: widget.scrollDirection,
      itemBuilder: (context, position) {
        if (position < _list.length) {
          if (position == 0) {
            return Column(
              verticalDirection: widget.reverse
                  ? VerticalDirection.up
                  : VerticalDirection.down,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.reverse ? widget.bottomWidget! : widget.topWidget!,
                widget.itemBuilder!(position, _list[position]),
                _list.length == 1
                    ? widget.reverse
                        ? widget.topWidget!
                        : widget.bottomWidget!
                    : Container()
              ],
            );
          } else if (position == _list.length - 1) {
            return Column(
              verticalDirection: widget.reverse
                  ? VerticalDirection.up
                  : VerticalDirection.down,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.itemBuilder!(position, _list[position]),
                widget.reverse ? widget.topWidget! : widget.bottomWidget!,
              ],
            );
          }
          return widget.itemBuilder!(position, _list[position]);
        } else if (position == _list.length && !_isEndOfList) {
          fetchMore();
          return widget.progress ?? defaultLoading();
        }
        return Container();
      },
    );
  }

  Widget defaultLoading() {
    return const Align(
      child: SizedBox(
        height: 40,
        width: 40,
        child: Padding(
          padding: EdgeInsets.all(8),
          // ignore: unnecessary_const
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

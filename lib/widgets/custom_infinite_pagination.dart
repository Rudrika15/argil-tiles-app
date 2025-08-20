import 'package:argil_tiles/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import '../utils/http_helper/http_helper.dart';
import '../utils/widgets/custom_primary_btn.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class UrlPagedList<T> extends StatefulWidget {
  const UrlPagedList({
    super.key,
    required this.url,
    required this.itemBuilder,
    required this.fromJson,
    this.headers,
    this.extraQuery,
    this.pageParam = 'page',
    this.perPageParam = 'per_page',
    this.initialPage = 1,
    this.pageSize = 20,
    this.padding,
    this.enableRefresh = true,
    this.isListView = true,
    this.searchQuery = '',
  });

  final String Function(String page,String query) url;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final FromJson<T> fromJson;
  final Map<String, String>? headers;
  final Map<String, String>? extraQuery;
  final String pageParam;
  final String perPageParam;
  final int initialPage;
  final int pageSize;
  final EdgeInsetsGeometry? padding;
  final bool enableRefresh;
  final bool isListView;
  final String searchQuery; // 👈 new

  @override
  State<UrlPagedList<T>> createState() => _UrlPagedListState<T>();
}

class _UrlPagedListState<T> extends State<UrlPagedList<T>> {
  late final PagingController<int, T> _controller;
  String _lastQuery = '';
  @override
  void initState() {
    super.initState();
    _controller = PagingController<int, T>(
      // Decide the next page key. Stop when the last page was shorter than pageSize.
      getNextPageKey: (state) {
        if ((state.pages?.isEmpty ?? true)) return widget.initialPage;
        final lastLen = state.pages!.last.length;
        if (lastLen < widget.pageSize) return null; // no more pages
        return state.nextIntPageKey; // convenience extension for int keys
      },
      // Fetch a page and return the items.
      fetchPage: (pageKey) async => _fetchPage(pageKey,widget.searchQuery),
    );
  }

  Future<List<T>> _fetchPage(int page ,String query) async {
    final resp = await HttpHelper.get(
      context: context,
      uri: widget.url(page.toString(),query),
    );

    // Flexible extraction: supports top-level list or common keys like data/results/items.
    List<dynamic> rawList;
    if (resp['data']['data'] is List) {
      rawList = resp['data']['data'];
    } else {
      throw const FormatException('Unexpected response shape.');
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map<T>((m) => widget.fromJson(m))
        .toList(growable: false);
  }

  @override
  void didUpdateWidget(covariant UrlPagedList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      // 👈 If query changed, refresh
      _lastQuery = widget.searchQuery;
      _controller.refresh();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagingListener<int, T>(
      controller: _controller,
      builder: (context, state, fetchNextPage) {
        final list =
            widget.isListView
                ? PagedListView<int, T>(
                  shrinkWrap: true,
                  padding: widget.padding,
                  state: state,
                  fetchNextPage:
                      fetchNextPage, // the magic: triggers loads as needed
                  builderDelegate: pagedChildBuilderDelegateMethod(
                    fetchNextPage,
                  ),
                )
                : PagedGridView<int, T>(
                  shrinkWrap: true,
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: pagedChildBuilderDelegateMethod(
                    fetchNextPage,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8 / 1,
                  ),
                );

        if (!widget.enableRefresh) return list;

        return RefreshIndicator(
          onRefresh: () async => _controller.refresh(),
          child: list,
        );
      },
    );
  }

  PagedChildBuilderDelegate<T> pagedChildBuilderDelegateMethod(
    NextPageCallback fetchNextPage,
  ) {
    return PagedChildBuilderDelegate<T>(
      itemBuilder: widget.itemBuilder,
      firstPageProgressIndicatorBuilder: (c) => const Loader(),
      newPageProgressIndicatorBuilder:
          (c) =>
              const Padding(padding: EdgeInsets.all(16), child: const Loader()),
      firstPageErrorIndicatorBuilder:
          (c) => _ErrorView(
            message: 'Failed to load.',
            onRetry: _controller.refresh,
          ),
      newPageErrorIndicatorBuilder:
          (c) => _ErrorView(
            message: 'Failed to load more.',
            onRetry: fetchNextPage,
          ),
      noItemsFoundIndicatorBuilder:
          (c) => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No items found'),
            ),
          ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 8),
            PrimaryBtn(width: 30.w, btnText: "Retry", onTap: onRetry),
          ],
        ),
      ),
    );
  }
}

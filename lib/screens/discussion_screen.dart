import 'package:flutter/material.dart';

import '../data/sample_people.dart';
import '../models/campus_event.dart';
import '../models/event_comment.dart';
import '../utils/app_colors.dart';
import '../widgets/initials_avatar.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key, required this.event});

  final CampusEvent event;

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final _commentController = TextEditingController();
  late final List<EventComment> _comments = commentsFor(widget.event.id);

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool get _canPost => _commentController.text.trim().isNotEmpty;

  void _post() {
    if (!_canPost) return;
    setState(() {
      _comments.add(
        EventComment(
          author: 'You',
          text: _commentController.text.trim(),
          time: DateTime.now(),
          isMine: true,
        ),
      );
      _commentController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _delete(EventComment comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete your comment?'),
        content: Text(
          'This comment will be removed from ${widget.event.title}. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep comment'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _comments.remove(comment));
  }

  @override
  Widget build(BuildContext context) {
    final count = _comments.length;
    final countLabel = count == 1 ? '1 comment' : '$count comments';

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'Discussion',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                children: [
                  Text(
                    widget.event.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$countLabel · Be respectful and stay on topic.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Text(
                        'No comments yet. Start the conversation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  for (final comment in _comments) ...[
                    _CommentCard(
                      comment: comment,
                      onDelete: comment.isMine ? () => _delete(comment) : null,
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Your comment',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    // Disabled while the field is empty.
                    onPressed: _canPost ? _post : null,
                    icon: const Icon(Icons.send_outlined, size: 18),
                    label: const Text('Post comment'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Comments are visible to everyone on this event.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment, this.onDelete});

  final EventComment comment;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InitialsAvatar(name: comment.author, radius: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.author,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formatShortDayTime(comment.time),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                TextButton(
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Delete'),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              comment.text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

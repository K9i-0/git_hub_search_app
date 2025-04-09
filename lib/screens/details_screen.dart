import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/repository.dart';
import '../utils/constants.dart';
import '../widgets/detail_item.dart';

class DetailsScreen extends StatelessWidget {
  final Repository repository;

  const DetailsScreen({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'repo_${repository.id}',
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(repository.owner.avatarUrl),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  repository.fullName,
                                  style: theme.textTheme.titleLarge,
                                ),
                                Text(
                                  'by ${repository.owner.login}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (repository.description.isNotEmpty) ...[  
                        const SizedBox(height: 16),
                        Text(
                          repository.description,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Repository Details',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3.5,
              children: [
                DetailItem(
                  label: AppConstants.detailsLanguage,
                  value: repository.language,
                  icon: Icons.code,
                ),
                DetailItem(
                  label: AppConstants.detailsStars,
                  value: repository.stargazersCount.toString(),
                  icon: Icons.star,
                  iconColor: Colors.amber,
                ),
                DetailItem(
                  label: AppConstants.detailsWatchers,
                  value: repository.watchersCount.toString(),
                  icon: Icons.visibility,
                ),
                DetailItem(
                  label: AppConstants.detailsForks,
                  value: repository.forksCount.toString(),
                  icon: Icons.fork_right,
                ),
                DetailItem(
                  label: AppConstants.detailsIssues,
                  value: repository.openIssuesCount.toString(),
                  icon: Icons.error_outline,
                  iconColor: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _launchUrl(context, repository.htmlUrl);
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text(AppConstants.detailsViewOnGithub),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to open URL'),
          action: SnackBarAction(
            label: 'Copy URL',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('URL copied to clipboard')),
              );
            },
          ),
        ),
      );
    }
  }
}
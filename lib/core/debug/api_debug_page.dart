import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/environment_config.dart';
import '../providers/app_providers.dart';
import '../providers/network_providers.dart';

/// Debug page to verify API configuration and test connectivity
/// This page helps verify that the localhost:3000 configuration is working correctly
class ApiDebugPage extends ConsumerWidget {
  const ApiDebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environmentInfo = ref.watch(environmentInfoProvider);
    final environmentDebug = ref.watch(environmentDebugInfoProvider);
    final apiConnectivityTest = ref.watch(apiConnectivityTestProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Configuration Debug'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEnvironmentCard(context, environmentInfo),
            const SizedBox(height: 16),
            _buildEndpointsCard(context, environmentDebug),
            const SizedBox(height: 16),
            _buildConnectivityTestCard(context, apiConnectivityTest, ref),
            const SizedBox(height: 16),
            _buildQuickActionsCard(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentCard(BuildContext context, Map<String, dynamic> info) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Environment Configuration',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Environment', info['environment']),
            _buildInfoRow('Base URL', info['baseUrl']),
            _buildInfoRow('API Path', info['apiPath'].isEmpty ? 'None (Direct)' : info['apiPath']),
            _buildInfoRow('Full Base URL', info['fullBaseUrl']),
            const Divider(),
            Text(
              'Timeout Settings',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Connect Timeout', '${info['timeouts']['connect']}ms'),
            _buildInfoRow('Receive Timeout', '${info['timeouts']['receive']}ms'),
            _buildInfoRow('Send Timeout', '${info['timeouts']['send']}ms'),
          ],
        ),
      ),
    );
  }

  Widget _buildEndpointsCard(BuildContext context, Map<String, dynamic> info) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.api,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'API Endpoints',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildEndpointRow(context, 'Login', '${info['baseUrl']}/auth/login'),
            _buildEndpointRow(context, 'Register', '${info['baseUrl']}/auth/register'),
            _buildEndpointRow(context, 'Refresh', '${info['baseUrl']}/auth/refresh'),
            _buildEndpointRow(context, 'Logout', '${info['baseUrl']}/auth/logout'),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectivityTestCard(
    BuildContext context,
    AsyncValue<Map<String, dynamic>> testResult,
    WidgetRef ref,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.network_check,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Connectivity Test',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    ref.read(apiConnectivityTestProvider.notifier).retry();
                  },
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Retry Test',
                ),
              ],
            ),
            const SizedBox(height: 16),
            testResult.when(
              data: (data) => _buildTestResult(context, data),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => _buildErrorResult(context, error.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _testLogin(context, ref),
                  icon: const Icon(Icons.login),
                  label: const Text('Test Login'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _testRegister(context, ref),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Test Register'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _copyConfiguration(context),
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Config'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndpointRow(BuildContext context, String name, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              url,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
          IconButton(
            onPressed: () => _copyToClipboard(context, url),
            icon: const Icon(Icons.copy, size: 16),
            tooltip: 'Copy URL',
          ),
        ],
      ),
    );
  }

  Widget _buildTestResult(BuildContext context, Map<String, dynamic> data) {
    final isSuccess = data['status'] == 'success';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSuccess
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                data['message'] ?? (isSuccess ? 'Test passed' : 'Test failed'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSuccess
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          if (data['timestamp'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Tested at: ${data['timestamp']}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorResult(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Error: $error',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _testLogin(BuildContext context, WidgetRef ref) {
    // This would be implemented based on your auth service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login test would be implemented here'),
      ),
    );
  }

  void _testRegister(BuildContext context, WidgetRef ref) {
    // This would be implemented based on your auth service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Register test would be implemented here'),
      ),
    );
  }

  void _copyConfiguration(BuildContext context) {
    final config = EnvironmentConfig.debugInfo;
    final configText = config.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');

    _copyToClipboard(context, configText);
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
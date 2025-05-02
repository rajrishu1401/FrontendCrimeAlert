import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/report.dart'; // Assuming you store the Report model here

class AuthorityHomeScreen extends StatefulWidget {
  const AuthorityHomeScreen({
    super.key,
    required this.id,
    required this.name,
    required this.dob,
    required this.phoneNo,
    required this.state,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  final String state;
  final String city;
  final String id;
  final String name;
  final String dob;
  final String phoneNo;
  final double latitude;
  final double longitude;

  @override
  State<AuthorityHomeScreen> createState() => _AuthorityHomeScreenState();
}

class _AuthorityHomeScreenState extends State<AuthorityHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<Report> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
    fetchReports();
  }

  Future<void> fetchReports() async {
    final url = Uri.parse('http://10.0.2.2:9090/authorityReports/${widget.id}'); // Adjust to your endpoint
    try {
      final response = await http.get(url);
      print("Raw response: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          reports = data.map((json) => Report.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching reports: $e");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        )),
        child: child,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : reports.isEmpty
              ? const Center(child: Text('No reports assigned'))
              : ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.report),
                  title: Text(report.description),
                  subtitle: Text('${report.location}\nStatus: ${report.status}'),
                  isThreeLine: true,
                  trailing: Text(
                    report.formattedTimestamp,  // Use the formatted timestamp here
                    style: const TextStyle(fontSize: 12),
                  ),

                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

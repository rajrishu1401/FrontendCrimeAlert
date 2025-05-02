class Report {
  final String reportId;
  final String citizenId;
  final String description;
  final String location;
  final int timestamp;
  final String status;

  Report({
    required this.reportId,
    required this.citizenId,
    required this.description,
    required this.location,
    required this.timestamp,
    required this.status,
  });

  // Convert the timestamp into a human-readable format
  String get formattedTimestamp {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.toLocal()}'.split('.')[0];  // Format date and remove milliseconds
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportId: json['reportId'],
      citizenId: json['citizenId'],
      description: json['description'],
      location: json['location'],
      timestamp: json['timestamp'],
      status: json['status'],
    );
  }
}

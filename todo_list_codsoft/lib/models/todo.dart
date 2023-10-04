class Todo {
  String id;
  String title;
  String description;
  TodoStatus status;
  TodoPriority priority;
  String dueDate;
  String timestamp;

  Todo({
    required this.title,
    this.id = "",
    this.description = '',
    this.status = TodoStatus.pending,
    this.priority = TodoPriority.normal,
    this.dueDate = '',
    this.timestamp = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'due_date': dueDate,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      id: json['id'],
      description: json['description'],
      status: TodoStatus.values
          .firstWhere((e) => e.toString().split('.').last == json['status']),
      priority: TodoPriority.values
          .firstWhere((e) => e.toString().split('.').last == json['priority']),
      dueDate: json['due_date'],
      timestamp: json['timestamp'],
    );
  }

  void updateStatus(TodoStatus status) {
    this.status = status;
  }

  void updatePriority(TodoPriority priority) {
    this.priority = priority;
  }
}

enum TodoStatus {
  pending,
  completed,
  active,
  deleted,
}

enum TodoPriority {
  urgent,
  high,
  normal,
  low,
}

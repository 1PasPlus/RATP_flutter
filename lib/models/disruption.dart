class Disruption {
  final String? disruptionId;
  final String? status;
  final String? cause;
  final String? category;
  final String? severity;
  final List<Message>? messages;
  final List<ImpactedObject>? impactedObjects;
  final String? updatedAt;

  Disruption({
    this.disruptionId,
    this.status,
    this.cause,
    this.category,
    this.severity,
    this.messages,
    this.impactedObjects,
    this.updatedAt,
  });

  factory Disruption.fromJson(Map<String, dynamic> json) {
    var messagesList = json['messages'] as List?;
    var impactedObjectsList = json['impacted_objects'] as List?;

    return Disruption(
      disruptionId: json['disruption_id'] as String?,
      status: json['status'] as String?,
      cause: json['cause'] as String?,
      category: json['category'] as String?,
      severity: json['severity'] as String?,
      messages: messagesList != null
          ? messagesList.map((i) => Message.fromJson(i)).toList()
          : [],
      impactedObjects: impactedObjectsList != null
          ? impactedObjectsList.map((i) => ImpactedObject.fromJson(i)).toList()
          : [],
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class Message {
  final String? text;
  final String? channel;
  final String? contentType;

  Message({this.text, this.channel, this.contentType});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] as String?,
      channel: json['channel'] as String?,
      contentType: json['content_type'] as String?,
    );
  }
}

class ImpactedObject {
  final String? objectId;
  final String? name;
  final String? type;
  final String? line;
  final String? stopArea;

  ImpactedObject({
    this.objectId,
    this.name,
    this.type,
    this.line,
    this.stopArea,
  });

  factory ImpactedObject.fromJson(Map<String, dynamic> json) {
    return ImpactedObject(
      objectId: json['object_id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      line: json['line'] as String?,
      stopArea: json['stop_area'] as String?,
    );
  }
}

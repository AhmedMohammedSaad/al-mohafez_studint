import 'dart:convert';

StorageModel storageModelFromJson(String str) => StorageModel.fromJson(json.decode(str));

String storageModelToJson(StorageModel data) => json.encode(data.toJson());

class StorageModel {
  factory StorageModel.fromJson(Map<dynamic, dynamic> json) => StorageModel(
        key: json['Key'],
        location: json['Location'],
      );
  StorageModel({
    required this.key,
    required this.location,
  });

  String key;
  String location;

  Map<dynamic, dynamic> toJson() => {
        'Key': key,
        'Location': location,
      };
}

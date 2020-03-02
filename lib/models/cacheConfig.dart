import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class CacheConfig {
    CacheConfig();

    bool enable;
    num maxAge;
    num maxCount;
}

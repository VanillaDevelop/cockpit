import 'package:cockpit/models/stream_of_consciousness/thought.dart';
import 'package:cockpit/models/stream_of_consciousness/thought_type.dart';

// Model that represents a collection of thoughts in a category / container
class ThoughtCategoryContainer {
  final String name;
  final ThoughtType thoughtType;
  final List<Thought> thoughts;
  bool visible;
  bool loading;

  // Default constructor
  ThoughtCategoryContainer(
    this.name,
    this.thoughts,
    this.visible,
    this.thoughtType,
  ) : loading = false;

  // Create default containers for each thought type
  static Map<ThoughtType, ThoughtCategoryContainer> createDefaultContainers() {
    return {
      ThoughtType.uncategorized: ThoughtCategoryContainer(
        'Uncategorized Thoughts',
        [],
        true,
        ThoughtType.uncategorized,
      ),
      ThoughtType.actionable: ThoughtCategoryContainer(
        'Actionable Thoughts',
        [],
        true,
        ThoughtType.actionable,
      ),
      ThoughtType.actioned: ThoughtCategoryContainer(
        'Actioned Thoughts',
        [],
        false,
        ThoughtType.actioned,
      ),
      ThoughtType.fleeting: ThoughtCategoryContainer(
        'Fleeting Thoughts',
        [],
        false,
        ThoughtType.fleeting,
      ),
    };
  }
}

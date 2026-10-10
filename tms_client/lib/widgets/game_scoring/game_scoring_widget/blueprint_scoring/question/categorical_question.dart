import 'package:material_ui/material_ui.dart';
import 'package:tms/generated/infra/fll_infra/category_question.dart';
import 'package:tms/widgets/buttons/category_button.dart';

class CategoricalQuestionWidget extends StatelessWidget {
  // questions with more options than this are shown as a counter, if they are a plain number range
  static const int _maxButtons = 8;

  final CategoricalQuestion catQuestion;
  final Function(String)? onAnswer;
  final String answer;

  const CategoricalQuestionWidget({
    super.key,
    required this.catQuestion,
    required this.onAnswer,
    required this.answer,
  });

  // true if the question is shown as a counter: a long list of options that are simply 0, 1, 2, ... n
  static bool usesCounter(CategoricalQuestion question) {
    final options = question.options;
    if (options.length <= _maxButtons) return false;
    for (var i = 0; i < options.length; i++) {
      if (options[i].label != i.toString()) return false;
    }
    return true;
  }

  Widget _categoryButton(String label) {
    // create container with min width of 100
    return Container(
      constraints: const BoxConstraints(minWidth: 80),
      child: IntrinsicWidth(
        child: CategoryButtonWidget(
          category: label,
          isSelected: answer == label,
          onSelected: (_) {
            onAnswer?.call(label);
          },
        ),
      ),
    );
  }

  Widget _wrappedCategoryButtons() {
    return Wrap(
      spacing: 2.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.end,
      children: [
        ...catQuestion.options.map((option) {
          return _categoryButton(option.label);
        }),
      ],
    );
  }

  Widget _stepButton(String label, int value, int step, int max) {
    return Container(
      constraints: const BoxConstraints(minWidth: 60),
      child: IntrinsicWidth(
        child: CategoryButtonWidget(
          category: label,
          isSelected: false,
          onSelected: (_) {
            onAnswer?.call((value + step).clamp(0, max).toString());
          },
        ),
      ),
    );
  }

  // compact counter for large number ranges, the answer is still one of the option labels
  Widget _counter() {
    final max = catQuestion.options.length - 1;
    final value = int.tryParse(answer) ?? 0;
    final bigSteps = max > 20;

    return Wrap(
      spacing: 2.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (bigSteps) _stepButton("-5", value, -5, max),
        _stepButton("-1", value, -1, max),
        Container(
          constraints: const BoxConstraints(minWidth: 80),
          child: IntrinsicWidth(
            child: CategoryButtonWidget(
              category: "$value",
              isSelected: true,
            ),
          ),
        ),
        _stepButton("+1", value, 1, max),
        if (bigSteps) _stepButton("+5", value, 5, max),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (usesCounter(catQuestion)) {
      return _counter();
    }
    return _wrappedCategoryButtons();
  }
}

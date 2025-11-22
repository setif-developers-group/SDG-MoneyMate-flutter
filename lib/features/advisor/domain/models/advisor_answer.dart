class AdvisorAnswer {
  final String answer;
  AdvisorAnswer({required this.answer});

  factory AdvisorAnswer.fromJson(Map<String, dynamic> json) => AdvisorAnswer(answer: json['answer']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'answer': answer};
}

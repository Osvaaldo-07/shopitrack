class ParamDialog {
  final String text;
  final void Function() onPresed;

  ParamDialog({required this.text, required this.onPresed});

  static ParamDialog fromJson(Map<String, dynamic> json){
    return ParamDialog(
      text: json['text'],
      onPresed: json['onPresed']
    );
  }
}

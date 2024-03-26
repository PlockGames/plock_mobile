import '../games/component.dart';

class ComponentRect extends Component {
  double width;
  double height;

  ComponentRect({
    this.width = 0,
    this.height = 0,
  });

  @override
  String get type => 'ComponentRect';
}
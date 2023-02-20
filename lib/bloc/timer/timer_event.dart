import 'package:equatable/equatable.dart';
import 'package:kanban_board/models/task.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  final int duration;
  const TimerStarted({required this.duration});

  @override
  List<Object> get props => [duration];
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerResumePrevious extends TimerEvent {
  final int duration;
  const TimerResumePrevious({required this.duration});

  @override
  List<Object> get props => [duration];
}


class TimerReset extends TimerEvent {}

class TimerTicked extends TimerEvent {
  final int duration;
  const TimerTicked({required this.duration});

  @override
  List<Object> get props => [duration];
}
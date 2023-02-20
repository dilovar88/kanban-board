import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:kanban_board/bloc/timer/timer_event.dart';
import 'package:kanban_board/bloc/timer/timer_state.dart';
import 'package:kanban_board/models/task.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Task task;
  final Ticker ticker = Ticker();
  /// to listen to the ticker stream
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required this.task}) : super(TimerInitial(task.totalDurationInSec)) {
    if (state is TimerInitial && task.isOn()) {
      _tickerSubscription?.cancel();

      /// triggers the TimerRunInProgress state
      emit(TimerRunInProgress(task.totalDurationInSec));

      /// makes the subscription listen to TimerTicked state
      _tickerSubscription = ticker
          .tick(ticks: task.totalDurationInSec)
          .listen((duration) => add(TimerTicked(duration: duration)));
    }

    on<TimerStarted>((event, emit) async{
      /// In case of there is an subscription exists, we have to cancel it
      _tickerSubscription?.cancel();

      /// start the task
      task.start();

      /// Save database
      await task.save();

      debug("Started");

      /// triggers the TimerRunInProgress state
      emit(TimerRunInProgress(event.duration));
      /// makes the subscription listen to TimerTicked state
      _tickerSubscription = ticker //task.lastTaskDurationTicker!
          .tick(ticks: event.duration)
          .listen((duration) => add(TimerTicked(duration: duration)));
    });

    on<TimerTicked>((event, emit) {
      emit(TimerRunInProgress(event.duration));
    });

    on<TimerPaused>((event, emit) async{
      /// As the timer pause, we should pause the subscription also
      _tickerSubscription?.pause();

      task.stop();

      /// Save database
      await task.save();

      debug("Paused");

      emit(TimerRunPause(state.duration)); /// triggers the TimerRunPause state
    });

    on<TimerResumed>((event, emit) async {
      /// As the timer resume, we must let the subscription resume also
      task.start();

      /// Save database
      await task.save();

      debug("Resumed");

      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration)); /// triggers the TimerRunInProgress state
    });

    on<TimerResumePrevious>((event, emit) async{
      /// In case of there is an subscription exists, we have to cancel it
      _tickerSubscription?.cancel();

      /// triggers the TimerRunInProgress state
      emit(TimerRunInProgress(event.duration));
      /// makes the subscription listen to TimerTicked state
      _tickerSubscription = ticker //task.lastTaskDurationTicker!
          .tick(ticks: event.duration)
          .listen((duration) => add(TimerTicked(duration: duration)));
    });

    on<TimerReset>((event, emit) => (event, emit) {
      /// Timer counting finished, so we must cancel the subscription
      _tickerSubscription?.cancel();

      task.resetTaskDurations();

      emit(const TimerInitial(0)); /// triggers the TimerInitial state
    });
  }

  @override
  Future<void> close() {
    /// cancel subscription
    _tickerSubscription?.cancel();
    return super.close();
  }

  debug(String type){
    if (kDebugMode) {
      print("${task.name} $type | Total Secs: ${task.totalDurationInSec} | Durations: ${task.taskDurations.length} | ${task.getDurations()}");
    }
  }
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks + x + 1);
  }
}
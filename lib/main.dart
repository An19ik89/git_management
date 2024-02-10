import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_management/bloc.dart';
import 'package:git_management/state.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CarouselBloc(5), // Adjust the image count as needed
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Carousel'),
      ),
      body: BlocBuilder<CarouselBloc, CarouselState>(
        builder: (context, state) {
          // Build your carousel UI using the state
          // You can use state.isFavorited, state.isAwarded, etc. to determine the status of each image
          // and display the appropriate UI elements.

          // Example:
          return ListView.builder(
            itemCount: state.isFavorited.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Image $index'),
                subtitle: Text('Status: ${state.isFavorited[index] ? 'Favorited' : 'Not Favorited'}'),
                // Add buttons and logic to handle button clicks
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: state.isFavorited[index] ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                      onPressed: () {
                        context.read<CarouselBloc>().add(ButtonClickedEvent(index, 'favorite'));
                      },
                    ),
                    IconButton(
                      icon: state.isAwarded[index] ? const Icon(Icons.star) : const Icon(Icons.star_border),
                      onPressed: () {
                        context.read<CarouselBloc>().add(ButtonClickedEvent(index, 'award'));
                      },
                    ),
                    IconButton(
                      icon: state.isClosed[index] ? const Icon(Icons.close) : const Icon(Icons.close),
                      onPressed: () {
                        context.read<CarouselBloc>().add(ButtonClickedEvent(index, 'close'));
                      },
                    ),
                    IconButton(
                      icon: state.isChatted[index] ? const Icon(Icons.chat) : const Icon(Icons.chat_bubble_outline),
                      onPressed: () {
                        context.read<CarouselBloc>().add(ButtonClickedEvent(index, 'chat'));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

abstract class CarouselEvent extends Equatable{}

class ButtonClickedEvent extends CarouselEvent {
  final int imageIndex;
  final String buttonType;

  ButtonClickedEvent(this.imageIndex, this.buttonType);

  @override
  List<Object?> get props => [imageIndex, buttonType];
}

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  CarouselBloc(int imageCount)
      : super(CarouselState(
    isFavorited: List.generate(imageCount, (index) => false),
    isAwarded: List.generate(imageCount, (index) => false),
    isClosed: List.generate(imageCount, (index) => false),
    isChatted: List.generate(imageCount, (index) => false),
  )
  );

  @override
  Stream<CarouselState> mapEventToState(CarouselEvent event) async* {
    if (event is ButtonClickedEvent) {
      final List<bool> newFavorited = List.from(state.isFavorited);
      final List<bool> newAwarded = List.from(state.isAwarded);
      final List<bool> newClosed = List.from(state.isClosed);
      final List<bool> newChatted = List.from(state.isChatted);

      switch (event.buttonType) {
        case 'favorite':
          newFavorited[event.imageIndex] = !state.isFavorited[event.imageIndex];
          break;
        case 'award':
          newAwarded[event.imageIndex] = !state.isAwarded[event.imageIndex];
          break;
        case 'close':
          newClosed[event.imageIndex] = !state.isClosed[event.imageIndex];
          break;
        case 'chat':
          newChatted[event.imageIndex] = !state.isChatted[event.imageIndex];
          break;
      }

      yield CarouselState(
        isFavorited: newFavorited,
        isAwarded: newAwarded,
        isClosed: newClosed,
        isChatted: newChatted,
      );
    }
  }
}

class CarouselState extends Equatable {
  final List<bool> isFavorited;
  final List<bool> isAwarded;
  final List<bool> isClosed;
  final List<bool> isChatted;

  CarouselState({
    required this.isFavorited,
    required this.isAwarded,
    required this.isClosed,
    required this.isChatted,
  });

  @override
  List<Object?> get props => [isFavorited, isAwarded, isClosed, isChatted];
}


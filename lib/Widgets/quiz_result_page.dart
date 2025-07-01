import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class QuizResultPage extends StatefulWidget {
  final int total;
  final int totalAnswer;
  final int failed;
  final int skipped;
  const QuizResultPage({super.key,
    required this.total,
    required this.failed,
    required this.skipped,
    required this.totalAnswer
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  late ConfettiController controller;

  @override
  void initState() {
    super.initState();
    controller = ConfettiController(duration: const Duration(seconds: 2));
    if (widget.totalAnswer == widget.total) {
      controller.play();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz',),
        automaticallyImplyLeading: false,
      ),
      body: const Column(
        children: [
          // ConfettiWidget(
          //   confettiController: controller,
          //   blastDirection: 2.0,
          //   blastDirectionality: BlastDirectionality.explosive, // Change directionality as needed
          //   particleDrag: 0.05, // Adjust particle drag
          //   emissionFrequency: 0.05, // Adjust emission frequency
          //   numberOfParticles: 50, // Number of particles
          //   gravity: 0.05, // Adjust gravity
          // ),
          // Container(
          //   decoration: const BoxDecoration(color: Colors.black12),
          //   height: height * 0.25,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          //     child: Row(
          //       children: [
          //         if (widget.total == widget.totalAnswer)
          //           SizedBox(
          //             height: 80,
          //             child: Image.asset(
          //               'assets/images/shuttle.png',
          //               fit: BoxFit.cover,
          //             )
          //           ),
          //         const SizedBox(width: 20,),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               widget.total == widget.totalAnswer
          //                 ? 'Well done!'
          //                 : '${widget.total} out of ${widget.totalAnswer} correct answers',
          //               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
          //             const SizedBox(
          //               height: 20,
          //             ),
          //             Text(
          //               widget.total == widget.totalAnswer
          //                   ? "Yor're ready for the next lecture"
          //                   : 'Try again or move on the next lecture',
          //               style: const TextStyle(fontSize: 14),
          //             )
          //           ],
          //         ),
          //       ],
          //     ),
          //   )
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       resultBox(
          //         height: height,
          //         width: width,
          //         icon: Icons.done,
          //         iconColor: Colors.green,
          //         data: '${widget.total}',
          //         type: 'Correct'
          //       ),
          //       resultBox(
          //         height: height,
          //         width: width,
          //         icon: CupertinoIcons.xmark,
          //         iconColor: Colors.red,
          //         data: '${widget.failed}',
          //         type: 'Incorrect'
          //       ),
          //       resultBox(
          //         height: height,
          //         width: width,
          //         icon: Icons.skip_next,
          //         iconColor: Colors.orange.shade300,
          //         data: '${widget.skipped}',
          //         type: 'Skipped'
          //       ),
          //     ],
          //   ),
          // ),
          // const Spacer(),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: width * 0.4,
          //         child: button(
          //           boxColor: Colors.transparent,
          //           textColor: Colors.black,
          //           name: 'Retry',
          //           onPressed: () {
          //             Navigator.of(context).pop();
          //           },
          //         ),
          //       ),
          //       const Spacer(),
          //       SizedBox(
          //         width: width * 0.4,
          //         child: button(
          //           name: 'Next Lecture',
          //           onPressed: () {
          //             Navigator.pop(context);
          //             Navigator.pop(context);
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        
        ],
      ),
    );
  }
}

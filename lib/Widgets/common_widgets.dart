

// Widget commonSubHeading(String name) {
//   return Text(
//     name,
//     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//   );
// }

// Widget resultBox({
//   required double height,
//   required double width,
//   required IconData icon,
//   required Color iconColor,
//   required String data,
//   required String type
// }) {
//   return Container(
//     height: 140,
//     width: 100,
//     decoration: BoxDecoration(border: Border.all(color: Colors.black), color: Colors.white38),
//     padding: const EdgeInsets.all(10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 25,
//           width: 25,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: iconColor,
//           ),
//           child: Icon(
//             icon,
//             size: 16,
//             color: Colors.black,
//           ),
//         ),
//         const Spacer(),
//         Text(
//           data,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         commonSubHeading(type)
//       ],
//     ),
//   );
// }

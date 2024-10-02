import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



// import 'dart:developer';
//
// import 'package:flutter/material.dart';
//
// import 'package:yellca/home/home_screen.dart';
//
// class SignupScreen extends StatefulWidget {
//   //TextFormField 에 입력된 값을 저장할 formkey
//   //GlobalKey: 외부 위젯에서 해당 위젯(globalkey가 등록된 위젯)의 state나 element에 접근하기 위한 key
//   final _formkey = GlobalKey<FormState>();
//   //const SignupScreen({super.key});
//
//   String userEmail = '';
//
//   //Form의 모든 TextFormField의 Validation == true 이면, 입력한 모든 text 저장하기
//   void _tryValidation() {
//     final _isValid = _formkey.currentState!.validate(); //bool 값 return ==> Validation이 true || false
//     if (_isValid) {
//       //모든 TextFormField의 값 저장
//       _formkey.currentState!.save();
//     }
//   }
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Center(
//             child: Text(
//               '회원가입',
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold
//               ),
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.home),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       body: Form(
//           //key: _formkey,
//           child: TextFormField(
//
//           ),
//       ),
//
//     );
//   }
// }
//
//
// // class SignupScreen extends StatefulWidget {
// //   const SignupScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<SignupScreen> createState() => _SignupScreenState();
// // }
// //
// // class _SignupScreenState extends State<SignupScreen> {
// //   final emailFormKey = GlobalKey<FormState>();
// //   int _currentStep = 0;
// //
// //   void _onStepCancel() {
// //     if (_currentStep <= 0) return;
// //     setState(() {
// //       _currentStep -= 1;
// //     });
// //   }
// //
// //   void _onStepContinue() {
// //     switch (_currentStep) {
// //       case 0:
// //         emailValidCheck().then((value) {
// //           if (value) {
// //             setState(() {
// //               log(userInputData.toString());
// //               _currentStep += 1;
// //             });
// //           }
// //         });
// //     }
// //
// //     List<Step> stepList = [
// //       //이메일 입력 단계
// //       Step(
// //         title: Text('이메일'),
// //         content: Form(
// //           key: emailFormKey,
// //           child: TextFormField(
// //             controller: controllers['email'],
// //             decoration: const InputDecoration(
// //               hintText: "이메일을 입력해주세요 :",
// //               errorBorder: UnderlineInputBorder(
// //                 borderSide: BorderSide(color: Colors.red, width: 2.0),
// //               ),
// //               focusedErrorBorder: UnderlineInputBorder(
// //                 borderSide: BorderSide(color: Colors.purple, width: 2.0),
// //               ),
// //             ),
// //             keyboardType: TextInputType.emailAddress,
// //             onChanged: (value) => userInputData['email'] = value,
// //             validator: (value) {
// //               if (value == null || value.isEmpty) {
// //                 return '이메일은 반드시 입력 해야 합니다!';
// //               }
// //               if (!EmailValidator.validate(value)) {
// //                 return '유효한 이메일을 입력해 주세요!';
// //               }
// //               if (!validation['email']!) {
// //                 return '이미 등록된 이메일 입니다!';
// //               }
// //               return null;
// //             },
// //           ),
// //         ),
// //       ),
// //     ];
// //
// //     @override
// //     Widget build(BuildContext context) {
// //       return Scaffold(
// //         appBar: AppBar(
// //           title: Center(
// //             child: Text(
// //               '회원가입',
// //               style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold
// //               ),
// //             ),
// //           ),
// //           actions: [
// //             IconButton(
// //               icon: Icon(Icons.home),
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => HomeScreen()),
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //
// //         body: Theme( //Theme은 앱 전체의 색상, 스타일, 그래픽 디자인 언어 등을 중앙에서 관리할 수 있게 해주는 기능
// //           data: ThemeData(
// //             colorScheme: const ColorScheme.light(primary: Colors.green),
// //
// //             ///Color(0xff020056),
// //           ),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Stepper(
// //               steps: stepList,
// //               type: StepperType.vertical,
// //               //현재 스탭 인덱스
// //               currentStep: _currentStep,
// //               //cancel 버튼을 탭하면 호출되는 콜백
// //               onStepCancel: _onStepCancel,
// //               //Continue 버튼을 탭하면 호출되는 콜백
// //               onStepContinue: _onStepContinue,
// //             ),
// //           ),
// //         ),
// //       );
// //     }
// //   }
// //
// //   Future<bool> emailValidCheck() async {
// //     await emailDuplicateCheck();
// //     return emailFormKey.currentState!.validate();
// //   }
// //
// // }
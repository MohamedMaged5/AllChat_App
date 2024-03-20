// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robochat/constants.dart';
import 'package:robochat/cubits/networkConnectivity/network_connectivity_cubit.dart';
import 'package:robochat/helpers/snackbar.dart';
import 'package:robochat/helpers/updateloginstatus.dart';
import 'package:robochat/models/message_model.dart';
import 'package:robochat/screens/login_screen.dart';
import 'package:robochat/widgets/alertdialog.dart';
import 'package:robochat/widgets/appname_connectivity_inappbar.dart';
import 'package:robochat/widgets/chat_bubble.dart';
import 'package:robochat/widgets/custom_textformfield.dart';
import 'package:robochat/widgets/nonetwork.dart';
import 'package:robochat/widgets/send_message_style.dart';

class ChatScreen extends StatefulWidget {
  final String? email;
  const ChatScreen({super.key, this.email});
  static String id = 'chatScreen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    context.read<NetworkConnectivityCubit>().CheckNetworkConnectivity();
    super.initState();
  }

  TextEditingController messageController = TextEditingController();
  final _controller = ScrollController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollection);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kTime, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messagesList = [];
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(MessageModel(
              message: snapshot.data!.docs[i][kMessage],
              id: snapshot.data!.docs[i][kId],
              messageTime: snapshot.data!.docs[i][kTime].toDate(),
            ));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 1,
              shadowColor: Colors.black,
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await LogoutOnPressed(context);
                    },
                    icon: const Icon(Icons.logout),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Image.asset(
                    "assets/images/app-logo.png",
                    scale: 2.5,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  const AppNameAndConnectivityInAppBar(),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await deleteAccountOnPressed(
                        context, snapshot, messagesList);
                  },
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<NetworkConnectivityCubit,
                      NetworkConnectivityState>(
                    builder: (context, state) {
                      if (state is NetworkConnectivityInitial) {
                        return ListView.builder(
                          controller: _controller,
                          itemCount: messagesList.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return messagesList[index].id == widget.email
                                ? ChatBubble(
                                    message: messagesList[index],
                                  )
                                : CHatBubbleOthers(
                                    message: messagesList[index]);
                          },
                        );
                      } else {
                        return const NoNetwork();
                      }
                    },
                  ),
                ),
                SendMessageStyle(
                  child: CustomTextFormField(
                    controller: messageController,
                    hintText: "Write your message",
                    bordercolor: Colors.transparent,
                    filled: true,
                    fillColor: Colors.white,
                    onsubmited: (data) {
                      context
                          .read<NetworkConnectivityCubit>()
                          .CheckNetworkConnectivity();
                      addMessageAndAnimate(data);
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        context
                            .read<NetworkConnectivityCubit>()
                            .CheckNetworkConnectivity();

                        addMessageAndAnimate(messageController.text);
                      },
                      icon: const Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Chat is not available right now, try again later!",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> deleteAccountOnPressed(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      List<MessageModel> messagesList) async {
    context.read<NetworkConnectivityCubit>().CheckNetworkConnectivity();
    final network = await (Connectivity().checkConnectivity());
    if (network == ConnectivityResult.mobile ||
        network == ConnectivityResult.wifi ||
        network == ConnectivityResult.ethernet) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialogBox(
            title: "Do you want to delete your account?",
            actionText: "Delete Account",
            onPressed: () async {
              await deleteUserAccount();
              snackBar(context, "Account Deleted");
              clearCurrentUserMessages(snapshot, messagesList);
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, ModalRoute.withName(ChatScreen.id));
              updateLoginStatus(false);
            },
          );
        },
      );
    }
  }

  Future<void> LogoutOnPressed(BuildContext context) async {
    context.read<NetworkConnectivityCubit>().CheckNetworkConnectivity();
    final network = await (Connectivity().checkConnectivity());
    if (network == ConnectivityResult.mobile ||
        network == ConnectivityResult.wifi ||
        network == ConnectivityResult.ethernet) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialogBox(
            title: "Do you want to Logout?",
            actionText: "Logout",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              snackBar(context, "Logged out successfully");
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, ModalRoute.withName(ChatScreen.id));
              updateLoginStatus(false);
            },
          );
        },
      );
    }
  }

  void addMessageAndAnimate(String input) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      if (messageController.text.isNotEmpty) {
        messages.add(
          {
            kMessage: input,
            kId: widget.email,
            kTime: DateTime.now(),
          },
        );

        messageController.clear();
        if (_controller.hasClients) {
          _controller.animateTo(0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn);
        }
      }
    }
  }

  void clearCurrentUserMessages(AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      List<MessageModel> messagesList) {
    snapshot.data!.docs.forEach((element) {
      if (element[kId] == widget.email) {
        messages
            .doc(element.id)
            .update({kMessage: "Account no longer exists    "});
      }
    });
  }
}

Future<void> deleteUserAccount() async {
  try {
    await FirebaseAuth.instance.currentUser!.delete();
  } on FirebaseAuthException catch (e) {
    log(e.toString());

    if (e.code == "requires-recent-login") {
      await _reauthenticateAndDelete();
    } else {
      log(e.toString());
    }
  } catch (e) {
    log(e.toString());
  }
}

Future<void> _reauthenticateAndDelete() async {
  try {
    final providerData = FirebaseAuth.instance.currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    }

    await FirebaseAuth.instance.currentUser?.delete();
  } catch (e) {
    log(e.toString());
  }
}

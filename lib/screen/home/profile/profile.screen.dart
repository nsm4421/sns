import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/api/user/user.api.dart';
import 'package:my_app/configurations.dart';
import 'package:my_app/domain/model/user/user.model.dart';
import 'package:my_app/repository/user/user.repository.dart';
import 'package:my_app/screen/component/feed.fragment.dart';
import 'package:my_app/screen/home/profile/notification.fragment.dart';
import 'package:my_app/screen/home/profile/reply.fragment.dart';

import 'edit_profile.widget.dart';

enum _ProfileTabItems {
  feed(label: 'Feed', fragment: FeedFragment(isMyFeed: true)),
  reply(label: 'Replies', fragment: ReplyFragment()),
  repost(label: 'Notification', fragment: NotificationFragment());

  final String label;
  final Widget fragment;

  const _ProfileTabItems({required this.label, required this.fragment});
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: _ProfileTabItems.values.length,
      vsync: this,
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // show edit profile view
  // when close edit profile view, init auth bloc
  _handleShowEditProfile() => showModalBottomSheet(
        context: context,
        builder: (context) => const EditProfileWidget(),
        showDragHandle: true,
        isScrollControlled: true,
        elevation: 0,
        enableDrag: true,
        isDismissible: true,
        useSafeArea: true,
        barrierColor: Colors.grey.withOpacity(0.5),
      );

  _handleSignOut() => context.read<UserRepository>().signOut();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<UserModel>(
                  stream: getIt<UserApi>().currentUserStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const SizedBox();
                    }
                    final user = snapshot.data;
                    return ListTile(
                      leading: (user?.profileImageUrls ?? []).isNotEmpty
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user!.profileImageUrls[0]),
                              radius: 25,
                            )
                          : const CircleAvatar(
                              child: Icon(Icons.account_circle_outlined)),
                      title: Text(user?.nickname ?? '',
                          style: GoogleFonts.karla(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      contentPadding: const EdgeInsets.all(0),
                      trailing: IconButton(
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: _handleSignOut,
                        tooltip: "Sign Out",
                      ),
                    );
                  }),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                InkWell(
                    onTap: _handleShowEditProfile,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.3)),
                      alignment: Alignment.center,
                      child: Text("Edit Profile",
                          style: GoogleFonts.karla(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary)),
                    )),
                InkWell(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.3)),
                      alignment: Alignment.center,
                      child: Text("Share Profile",
                          style: GoogleFonts.karla(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary)),
                    ))
              ]),
              const SizedBox(height: 30),
              TabBar(
                controller: _controller,
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorColor: Theme.of(context).colorScheme.secondary,
                tabs: _ProfileTabItems.values
                    .map((e) => SizedBox(
                        width: double.infinity, child: Tab(text: e.label)))
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                    controller: _controller,
                    children: _ProfileTabItems.values
                        .map((e) => e.fragment)
                        .toList()),
              )
            ],
          ),
        ),
      );
}

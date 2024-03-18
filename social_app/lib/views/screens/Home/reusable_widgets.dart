import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/provider/auth/auth.dart';
import 'package:social_app/provider/post_provider.dart';
import 'package:social_app/views/screens/add_post_screen/add_comment.dart';
import 'package:social_app/views/screens/add_post_screen/post.dart';
import 'package:social_app/views/screens/add_post_screen/test_screen.dart';
import 'package:social_app/views/screens/profile_screen/friend_profile.dart';

// This widget is responsible for fetching and displaying posts from the server.
class PostsFutureBuilder extends StatefulWidget {
  const PostsFutureBuilder({super.key});

  @override
  State<PostsFutureBuilder> createState() => _PostsFutureBuilderState();
}

class _PostsFutureBuilderState extends State<PostsFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    final AuthController authController =
        Provider.of<AuthController>(context, listen: true);
    final PostController postController =
        Provider.of<PostController>(context, listen: false);
    return FutureBuilder(
      future: postController.getPosts(authController.mainUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          // handle the case when data is successfully fetched
          return Column(
            children: [
              SizedBox(
                height: 500,
                child: SingleChildScrollView(
                  child: Selector<AuthController, int>(
                    selector: (context, authController) =>
                        authController.mainUser.friends!.length,
                    builder: (context, friendsCount, child) {
                      print(
                          "selector for friends---------------------------------");

                      return Column(
                        children: [
                          ...List.generate(
                              postController.posts.length,
                              (i) => PostCard(
                                  i: i,
                                  navigateToAddcomment: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => PreviewPostPage(
                                                post: postController.posts[i],
                                              ))),
                                  postText: postController.posts[i]['text'],
                                  press: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => FriendProfile(
                                            friend: authController.usersMap[
                                                postController.posts[i]
                                                    ['owner']]!,
                                          ),
                                        ),
                                      ),
                                  time: postController.posts[i]
                                      ['time'], // Add the 'time' argument here
                                  imageUrl: postController.posts[i]['imageUrl'],
                                  isliked:
                                      (postController.posts[i]['likers'] ?? [])
                                          .contains(
                                              authController.mainUser.userUID),
                                  avatarImage: authController
                                      .usersMap[postController.posts[i]
                                          ['owner']]
                                      ?.avatar,
                                  userName: authController
                                      .usersMap[postController.posts[i]
                                          ['owner']]
                                      ?.userName,
                                  likesNumber:
                                      (postController.posts[i]['likers'] ?? []).length,
                                      commentsNumber: (postController.posts[i]['comments']??[]).length,
                                  likeFunction: () async {
                                    await postController.likePost(
                                        liker: authController.mainUser.userUID!,
                                        post: postController.posts[i]);
                                  })),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

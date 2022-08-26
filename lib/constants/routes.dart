import 'package:flutter/material.dart';
import 'package:pearmeta_fapp/views/about_us.dart';
import 'package:pearmeta_fapp/views/account_manage.dart';
import 'package:pearmeta_fapp/views/art_detail.dart';
import 'package:pearmeta_fapp/views/bankcard_list.dart';
import 'package:pearmeta_fapp/views/home_wrapper.dart';
import 'package:pearmeta_fapp/views/identity.dart';
import 'package:pearmeta_fapp/views/identity_detail.dart';
import 'package:pearmeta_fapp/views/invite_friends.dart';
import 'package:pearmeta_fapp/views/invite_records.dart';
import 'package:pearmeta_fapp/views/login.dart';
import 'package:pearmeta_fapp/views/order_detail.dart';
import 'package:pearmeta_fapp/views/orders.dart';
import 'package:pearmeta_fapp/views/search_screen.dart';
import 'package:pearmeta_fapp/views/setting.dart';
import 'package:pearmeta_fapp/views/signup.dart';
import 'package:pearmeta_fapp/views/topup_store.dart';
import 'package:pearmeta_fapp/views/user_arts.dart';
import 'package:pearmeta_fapp/views/user_change_password.dart';
import 'package:pearmeta_fapp/views/user_edit.dart';
import 'package:pearmeta_fapp/views/wallet.dart';

Map<String, Widget Function(BuildContext)> routes = {
  HomeWrapper.routeName: (context) => const HomeWrapper(title: 'PEARMETA'),
  Login.routeName: (context) => const Login(),
  Signup.routeName: (context) => const Signup(),
  Setting.routeName: (context) => const Setting(),
  Identity.routeName: (context) => const Identity(),
  InviteFriends.routeName: (context) => const InviteFriends(),
  SearchScreen.routeName: (context) => const SearchScreen(),
  Orders.routeName: (context) => const Orders(),
  UserArts.routeName: (context) => const UserArts(),
  ArtDetail.routeName: (context) => const ArtDetail(),
  Wallet.routeName: (context) => const Wallet(),
  UserEdit.routeName: (context) => const UserEdit(),
  AccountManage.routeName: (context) => const AccountManage(),
  UserChangePassword.routeName: (context) => const UserChangePassword(),
  IdentityDetail.routeName: (context) => const IdentityDetail(),
  TopupStore.routeName: (context) => const TopupStore(),
  OrderDetail.routeName: (context) => const OrderDetail(),
  InviteRecords.routeName: (context) => const InviteRecords(),
  AboutUs.routeName: (context) => const AboutUs(),
  BankCardManage.routeName: (context) => const BankCardManage(),
};

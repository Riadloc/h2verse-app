import 'package:flutter/material.dart';
import 'package:h2verse_app/views/about.dart';
import 'package:h2verse_app/views/acount/trade_password_form.dart';
import 'package:h2verse_app/views/airdrop/airdrop_detail.dart';
import 'package:h2verse_app/views/airdrop/airdrop_list.dart';
import 'package:h2verse_app/views/community/customer_service.dart';
import 'package:h2verse_app/views/community/groups.dart';
import 'package:h2verse_app/views/compose/compose_lab.dart';
import 'package:h2verse_app/views/compose/compose_list.dart';
import 'package:h2verse_app/views/detail/art_gift_transfer.dart';
import 'package:h2verse_app/views/fuel/fule_list.dart';
import 'package:h2verse_app/views/my_webview.dart';
import 'package:h2verse_app/views/acount/account_manage.dart';
import 'package:h2verse_app/views/acount/bankcard_bind_form.dart';
import 'package:h2verse_app/views/bulletin/bulletin.dart';
import 'package:h2verse_app/views/detail/art_detail.dart';
import 'package:h2verse_app/views/acount/bankcard_list.dart';
import 'package:h2verse_app/views/home_wrapper.dart';
import 'package:h2verse_app/views/identity.dart';
import 'package:h2verse_app/views/acount/identity_detail.dart';
import 'package:h2verse_app/views/invite_friends.dart';
import 'package:h2verse_app/views/invite_records.dart';
import 'package:h2verse_app/views/login.dart';
import 'package:h2verse_app/views/order/order_detail.dart';
import 'package:h2verse_app/views/order/order_form.dart';
import 'package:h2verse_app/views/order/orders.dart';
import 'package:h2verse_app/views/search_screen.dart';
import 'package:h2verse_app/views/setting.dart';
import 'package:h2verse_app/views/signup.dart';
import 'package:h2verse_app/views/user/user_destory.dart';
import 'package:h2verse_app/views/wallet/drawcash_form.dart';
import 'package:h2verse_app/views/wallet/record_detail.dart';
import 'package:h2verse_app/views/wallet/topup_form.dart';
import 'package:h2verse_app/views/wallet/topup_store.dart';
import 'package:h2verse_app/views/user/user_address.dart';
import 'package:h2verse_app/views/user_arts.dart';
import 'package:h2verse_app/views/user/user_change_password.dart';
import 'package:h2verse_app/views/user/user_edit.dart';
import 'package:h2verse_app/views/wallet/wallet.dart';
import 'package:h2verse_app/views/wallet/wallet_list_wrapper.dart';

Map<String, Widget Function(BuildContext)> routes = {
  HomeWrapper.routeName: (context) => const HomeWrapper(),
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
  TradePasswordForm.routeName: (context) => const TradePasswordForm(),
  UserChangePassword.routeName: (context) => const UserChangePassword(),
  IdentityDetail.routeName: (context) => const IdentityDetail(),
  TopupStore.routeName: (context) => const TopupStore(),
  OrderForm.routeName: (context) => const OrderForm(),
  ArtGiftTransfer.routeName: (context) => const ArtGiftTransfer(),
  OrderDetail.routeName: (context) => const OrderDetail(),
  InviteRecords.routeName: (context) => const InviteRecords(),
  MyWebview.routeName: (context) => const MyWebview(),
  BankCardManage.routeName: (context) => const BankCardManage(),
  UserAddress.routeName: (context) => const UserAddress(),
  WalletListWrapper.routeName: (context) => const WalletListWrapper(),
  RecordDetail.routeName: (context) => const RecordDetail(),
  TopupForm.routeName: (context) => const TopupForm(),
  DrawcashForm.routeName: (context) => const DrawcashForm(),
  BankCardBindForm.routeName: (context) => const BankCardBindForm(),
  BulletinList.routeName: (context) => const BulletinList(),
  ComposeList.routeName: (context) => const ComposeList(),
  ComposeLab.routeName: (context) => const ComposeLab(),
  FuleStore.routeName: (context) => const FuleStore(),
  UserDestory.routeName: (context) => const UserDestory(),
  AirdropList.routeName: (context) => const AirdropList(),
  AirdropDetail.routeName: (context) => const AirdropDetail(),
  CommunityGroups.routeName: (context) => const CommunityGroups(),
  CustomerService.routeName: (context) => const CustomerService(),
  About.routeName: (context) => const About(),
};

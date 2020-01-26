import 'dart:async';
import 'package:breve/models/transaction/wallet-reload.dart';
import 'package:breve/services/database.dart';
import 'package:breve/widgets/customer/menu/product/constrained_picker_tile.dart';
import 'package:breve/widgets/customer/menu/product/selectable_group.dart';
import 'package:breve/widgets/general/breve_card.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:breve/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:breve/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'card_picker_inline.dart';

class Wallet extends StatefulWidget {

  @override
  _WalletState createState() =>
      _WalletState();
}

class _WalletState extends State<Wallet> {
  

  Future<bool> submitReload(WalletReload r) async {
    
     
      bool succeeded = (await r.push(Firestore.instance.collection("transactions"))).exists;

    if(!succeeded) Dialogs.showErrorDialog(context, "title", "message");
    else r = new WalletReload();
  }

  

 

  @override
  Widget build(BuildContext context) {
   return LargeBreveCard(child: 
   ChangeNotifierProvider<WalletReload>(builder: (_) => WalletReload(), 
                  child: Consumer<WalletReload>(builder: (context, reload, _) => 
   Column(
          mainAxisSize: MainAxisSize.min,
        
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding:
                    EdgeInsets.only(left: 32, top: 16, bottom: 16, right: 32),
                child: Row(children: [
                  Text("Balance",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                  Spacer(),
                  
                  StreamBuilder(
                    stream: CustomerDatabase.instance.userDoc.snapshots().map((doc) => doc["walletBalance"])
                  , builder: (context, AsyncSnapshot snap) =>
                  Text(
                      snap.data == null
                          ? "..."
                          : NumberFormat.simpleCurrency().format(snap.data / 100),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
                  )
                ])),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child:
                  
            Column(
            children: [
              
              ConstrainedPickerTile(SelectableGroup<int>.singleChoice(name: "Reload", options: [100, 200, 300],
              
               value: reload.amount,  getOptionName: (o) => formatPrice(o), onSelectionUpdate: (x) => reload.amount = x
            
              ),
              trailValue: (o) => formatPrice(o.length == 0 ? 0 : o.first),
              bigTitle: true,
              ),
              
              InlineCardPicker(
                  onUpdated: (id) {
                      reload.source = id;
                  })
            ])),

            Padding(padding: EdgeInsets.all(16), child: Row(children: [
          Expanded(
              child: CustomButton(
                isLoading: reload.isPushing,
                  title: reload.isValid 
                          ?
                          "Reload " +
                      NumberFormat.simpleCurrency().format(reload.amount / 100) : "Select options",
                  onPressed:
                      reload.isValid  ?
                              () => submitReload(reload)
                            
                          : null))
        ]))
          ]))));
        
  }
}
import 'dart:async';

import 'package:snackk/services/database.dart';
import 'package:snackk/widgets/customer/credit_cards/credit_card_modal.dart';
import 'package:snackk/widgets/customer/menu/product/select_tile.dart';
import 'package:snackk/widgets/customer/menu/product/selectable_group.dart';
import 'package:snackk/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:snackk/models/credit_card_preview.dart';

class InlineCardPicker extends StatefulWidget {
  Function(String) onUpdated;

  InlineCardPicker({this.onUpdated});

  @override
  _InlineCardPickerState createState() => _InlineCardPickerState();
}

class _InlineCardPickerState extends State<InlineCardPicker> {
  CreditCardPreview selectedPaymentMethod;

  void onUpdate(CreditCardPreview s) {
    setState(() {
      selectedPaymentMethod = s;
      widget.onUpdated(s?.id);
    });
  }

  void willSetDefault(s) async {
    Timer(new Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() => selectedPaymentMethod = s);
        widget.onUpdated(s?.id);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: CustomerDatabase.instance.sourcesQuery.snapshots().map((q) =>
            q.documents.map((d) => CreditCardPreview.fromDocument(d)).toList()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<CreditCardPreview> cards = snapshot.data;
          if (cards?.length == 1 && !cards[0].isPushing)
            willSetDefault(cards[0]);
          return ConstrainedPickerTile(
            SelectableGroup<CreditCardPreview>.singleChoice(
                name: "Credit card",
                options: cards,
                value: selectedPaymentMethod,
                getOptionName: (CreditCardPreview c) => c?.last4,
                isOptionLoading: (c) => c?.isPushing,
                onSelectionUpdate: (l) => onUpdate(l)),
            addText: cards?.length == 0 ? "Add card  " : null,
            onAdd: Routes.willPush(context, CreditCardModal()),
            bigTitle: true,
          );
        });
  }
}

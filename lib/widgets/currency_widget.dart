import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/currency_list.dart';
import '../providers/currency_provider.dart';
import '../models/currency_type.dart';
import '../screens/detailed_currency_screen.dart';
import '../widgets/current_value.dart';

class CurrencyWidget extends StatefulWidget {
  final CurrencyType list;
  CurrencyWidget(this.list);

  @override
  _CurrencyWidgetState createState() => _CurrencyWidgetState();
}

class _CurrencyWidgetState extends State<CurrencyWidget> {
  Widget _buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Emin Misiniz?",
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.black,
              fontSize: 24,
            ),
      ),
      content: Text(
          "Bu para birimine ait bütün kayıtlı verileriniz silinecektir.",
          style: Theme.of(context).textTheme.bodyText2),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Hayır")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Evet")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CurrencyProvider>(context, listen: false);
    return Dismissible(
      confirmDismiss: (value) {
        return showDialog(
            context: context,
            builder: (_) {
              return _buildAlertDialog(context);
            });
      },
      onDismissed: (direction) async {
        await _provider.deleteItem(widget.list.id);
        //widget.mainSetState();
      },
      key: ObjectKey(widget.list),
      background: Container(
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        padding: const EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      child: Column(
        children: [
          ListTile(
            title: Text(CurrencyMap.currency[widget.list.currencyCode]),
            subtitle: CurrentValue(
              value: widget.list.currencyCode,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Theme.of(context).accentColor,
            ),
            onTap: () => Navigator.of(context).pushNamed(
              DetailedScreen.routeName,
              arguments: widget.list,
            ),
          ),
          Divider(
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}

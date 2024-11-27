part of 'widgets.dart';

class CardCost extends StatefulWidget {
  final Costs cost;
  const CardCost(this.cost);

  @override
  State<CardCost> createState() => _CardCostState();
}

class _CardCostState extends State<CardCost> {
  String rupiahMoneyFormatter(int? value) {
    if (value == null) return "Rp0,00";
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    Costs cost = widget.cost;

    Cost firstCost = cost.cost?.isNotEmpty ?? false ? cost.cost![0] : Cost();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsetsDirectional.symmetric(vertical: 6, horizontal: 16),
      color: Colors.blueAccent,
      elevation: 4,
      child: ListTile(
          title: Text(
              style: TextStyle(color: Colors.white),
              "${cost.description} (${cost.service})"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  style: TextStyle(color: Colors.white),
                  "Biaya: ${rupiahMoneyFormatter(firstCost.value)}"),
              SizedBox(height: 4),
              Text(
                  style: TextStyle(color: Colors.lightGreenAccent),
                  "Estimasi sampai: ${firstCost.etd} hari"),
            ],
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.local_shipping, color: Colors.blueAccent),
          )),
    );
  }
}

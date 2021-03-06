import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/poke-stat.dart';
import 'package:pokedex/res/my-colors.dart';

class PokeStatRow extends StatefulWidget {
  final PokeStat stat;

  PokeStatRow({@required this.stat});

  @override
  _PokeStatRowState createState() => _PokeStatRowState();
}

class _PokeStatRowState extends State<PokeStatRow> {
  final GlobalKey progressBarKey = GlobalKey();
  double barWidth = 0;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _calculateBarWidth(),
    );
  }

  _calculateBarWidth() {
    final keyContext = progressBarKey.currentContext;

    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      setState(() {
        barWidth = box.size.width * (widget.stat.value / 100);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 30,
            child: Text(
              widget.stat.name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: widget.stat.color,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 10,
            child: Text(
              widget.stat.value.toString(),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 60,
            child: Container(
              key: progressBarKey,
              height: 10,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: MyColors.gallery,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: barWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.stat.color.withOpacity(0.6),
                      widget.stat.color,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

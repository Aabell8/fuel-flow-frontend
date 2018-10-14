import 'package:flutter/material.dart';
import 'package:fuelflow/model/person.dart';

class TaskListItem extends ListTile {
  TaskListItem(Person item, VoidCallback verifyDrink, String name)
      : super(
          key: new Key(item.id),
          isThreeLine: false,
          title: new Text(
            '${item.name}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: new Text(
            'Drinks: ${item.drinks}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: item.isRequesting && name.toLowerCase() != item.id.toLowerCase()
              ? IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: verifyDrink,
                )
              : null,
        );
}

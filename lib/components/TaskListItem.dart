import 'package:flutter/material.dart';
import 'package:fuelflow/model/person.dart';

class TaskListItem extends ListTile {
  TaskListItem(Person item)
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
          trailing: item.isRequesting
              ? IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () {
                    print("Clicked ${item.name}");
                  },
                )
              : null,
        );
}

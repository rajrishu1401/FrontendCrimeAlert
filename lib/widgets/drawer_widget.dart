import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key,required this.changeScreen});
  final void Function(String screen) changeScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.55),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.menu_open,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 48,
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Text(
                    'Menu',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.account_circle_rounded,size: 26,color:Theme.of(context).colorScheme.onSurface,),
                  title: Text('Your Profile',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                    ),),
                  onTap: (){
                    changeScreen('Profile');
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.group,size: 26,color:Theme.of(context).colorScheme.onSurface,),
                  title: Text('Community',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                    ),),
                  onTap: (){
                    changeScreen('Community');
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.language,size: 26,color:Theme.of(context).colorScheme.onSurface,),
                  title: Text('Change Language',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                    ),),
                  onTap: (){
                    changeScreen('language');
                  },
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.help_center_outlined,size: 26,color:Theme.of(context).colorScheme.onSurface,),
            title: Text('Help',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
              ),),
            onTap: (){
              changeScreen('Help');
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const ShellScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 500) {
      return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 165, 243),
        title: Text("Kalimati", style: TextStyle(color: Colors.white,fontFamily: 'cursive', fontWeight:FontWeight.bold, fontSize: 30),),
        
        toolbarHeight: 80,

      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            selectedIconTheme: IconThemeData(color: Color.fromARGB(255, 120, 165, 243)),

            onDestinationSelected: (index) {
              if (index == 0) {
                context.push('/home'); }
              else if (index == 1) {
                context.push('/games'); }
              else if (index == 2) 
                {context.push('/packages');}
              else if (index == 3){
                context.push('/login');
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(icon: Icon(Icons.games_outlined), selectedIcon: Icon(Icons.games), label: Text('Games')),
              NavigationRailDestination(icon: Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box), label: Text('Packages')),
              NavigationRailDestination(icon: Icon(Icons.manage_accounts_outlined), selectedIcon: Icon(Icons.manage_accounts), label: Text('Manage')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1,),
          Expanded(child: child),
        ],
      ),
    );
    }
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 165, 243),
        title: Text("Kalimati", style: TextStyle(color: Colors.white,fontFamily: 'cursive', fontWeight:FontWeight.bold, fontSize: 30),),
        
        toolbarHeight: 80,

      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 120, 165, 243), 
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            context.push('/home'); }
          else if (index == 1) {
            context.push('/games'); }
          else if (index == 2) 
            {context.push('/packages');}
          else if (index == 3){
            context.push('/login');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.games_outlined), activeIcon: Icon(Icons.games), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), activeIcon: Icon(Icons.add_box), label: 'Packages'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts_outlined), activeIcon: Icon(Icons.manage_accounts), label: 'Manage'),
        ],

      ),
      
  );
  }
}

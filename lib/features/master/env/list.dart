import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leontech/core/models/envmodel.dart';
import 'package:leontech/core/services/fastscript.dart';
import 'package:leontech/core/utils/function.dart';
// ignore: unused_import
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/widgets/editor/customtext.dart';

class ListEnv extends StatefulWidget {
  const ListEnv({super.key});

  @override
  State<ListEnv> createState() => _ListEnvState();
}

class _ListEnvState extends State<ListEnv> {
  bool isSearching = false;
  final searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  // Fungsi untuk memuat lebih banyak barang (pagination)

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: isSearching
              ? TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari Env',
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (value) {
                      _debouncer.run(() {
                   /*  _pagingController.nextPageKey = 0;
                    _pagingController.refresh(); */
                  });
                    
                  },
                )
              : const CustomTextAppBar(text: 'Daftar Env', fontSize: 14),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState((){
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                /*     _pagingController.nextPageKey = 0;
                    _pagingController.refresh();        */           
                }
                
                });
              },
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res =await  Get.toNamed('/env/edit');
          if (res is EnvModel){
            setState(() {
              fs.add(res);
            });
          }

        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        onRefresh: () async{
          await FastScript.fetch();
          setState(() {
            
          });
        },
        
        child: ListView.builder(
          itemCount: fs.length,
            itemBuilder: (context, index) {
              return ListTile(
                
                onTap: ()async{
                  
                  var res = await Get.toNamed('/env/edit', arguments: fs[index]);
                  if(res is EnvModel){
                    fs[index] = res;
                    setState(() {
                      
                    });
                  }
                
                },
                title: Text(fs[index].nama.toString(),style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: Text(fs[index].skrip??''),
                trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteEnv(fs[index].id); // Trigger the delete function
                },
              ),
                
              );}
        ),
      ),
          
        
    );
  }
  Future<void> _deleteEnv(int? id) async {
    // Show a confirmation dialog before deleting
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async{
              var res = await FastScript.deleteEnv(id);
              Get.back(result:  res);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    // If user confirms, delete the item
    if (confirmDelete) {
      setState(() {
        fs.removeWhere((x) => x.id == id); // Remove the item from the list
      });
      // Optionally, you can call a service to delete from the backend
      // await FastScript.deleteEnv(fs[index]);
    }
  }
}


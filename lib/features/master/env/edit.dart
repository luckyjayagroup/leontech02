import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leontech/core/models/envmodel.dart';
import 'package:leontech/core/services/fastscript.dart';
class EnvEditor extends StatefulWidget {
  final EnvModel? id;
  const EnvEditor(this.id,{ super.key});

  @override
  State<EnvEditor> createState() => _EnvEditorState();
}

class _EnvEditorState extends State<EnvEditor> {
  var newdata = EnvModel();
  @override
  void initState() {
    newdata = widget.id??EnvModel();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Env Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                initialValue: newdata.nama,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  newdata.nama = value;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: newdata.skrip,
                decoration: const InputDecoration(labelText: 'Skrip'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a script';
                  }
                  return null;
                },
                onChanged: (value) {
                  newdata.skrip = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: ()async{
                 var res = await FastScript.update(newdata);
                 if(res is EnvModel){
                  newdata = res;
                
                  Get.back(result: newdata);
                 }
                  
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

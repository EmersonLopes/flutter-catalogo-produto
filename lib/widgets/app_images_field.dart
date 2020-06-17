import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'app_image_source_sheet.dart';

class AppImagesField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormField<List>(
      initialValue: [],
      builder: (FormFieldState field) {
        return Column(
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: field.value.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == field.value.length)
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((_) {
                              return AppimageSourceSheet((file) {
                                field.didChange(field.value..add(file));
                              });
                            }));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.photo_camera,
                                size: 50.0,
                                color: Theme.of(context).primaryColor),
                            Text(
                              'Incluir imagem',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor),
                            )
                          ],
                        ),
                      ),
                    );
                  return
                    Stack(
                      children: <Widget>[
                        Container(
//                          margin: EdgeInsets.all(16.0),
                            padding: const EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Image.file(field.value[index], fit: BoxFit.cover)),
                        Positioned(
                          top: 1,
                          left: 1,
                          child: IconButton(icon: Icon(Icons.delete, color: Colors.black26, size: 32.0,),onPressed: (){},),
                        )
                      ],
                    );



                },
              ),
            )
          ],
        );
      },
    );
  }
}

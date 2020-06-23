import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycatalog/utils/dialogs.dart';
import 'package:transparent_image/transparent_image.dart';

import 'app_image_source_sheet.dart';

class AppImagesField extends StatelessWidget {
  final FormFieldSetter<List> onSaved;
  final List initialValue;

  AppImagesField({this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return FormField<List>(
      onSaved: onSaved,
      initialValue: initialValue,
      builder: (FormFieldState field) {
        return Column(
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              height: MediaQuery.of(context).size.height * 0.3,
              child: field.value.length == 0
                  ? TirarFoto(context, field)
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: field.value.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (field.value.length == index)
                          return TirarFoto(context, field);

                        return Foto(context, field, index);
                      },
                    ),
            )
          ],
        );
      },
    );
  }

  Widget TirarFoto(BuildContext context, FormFieldState field) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: ((_) {
              return Container(
                child: AppimageSourceSheet((file) {
                  if (file != null) field.didChange(field.value..add(file));
                }),
              );
            }));
      },
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.photo_camera, size: 50.0, color: Colors.black26),
            Text(
              'Incluir imagem',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black26),
            )
          ],
        ),
      ),
    );
  }

  Widget Foto(BuildContext context, FormFieldState field, int index) {
    return Stack(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.7,
            child: initialValue.length>0?
            Image.memory(field.value[index], fit: BoxFit.cover):
    Image.file(field.value[index], fit: BoxFit.cover)),
        Positioned(
          bottom: 5,
          right: 5,
          child: IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.red[400],
              size: 32.0,
            ),
            onPressed: () async {
              bool ok = await Dialogs.showQuestion(context, 'Excluir imagem', 'Deseja excluir imagem?');
              if(ok){
                (field.value as List).remove(field.value[index]);
                field.didChange(field.value);
              }
            },
          ),
        )
      ],
    );
  }
}
